/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * Description: BaseBuilder is a common funnel through which both CriteriaBuilder and DetachedCriteriaBuilder can be run
 * It exposes properties and methods that both builders share in common, for a singular mechanism for building
 * criteria queries and subqueries
 */
import cborm.models.*;
import org.hibernate.*;
component accessors="true" {

	/**
	 * The native criteria object: https://docs.jboss.org/hibernate/orm/5.2/javadocs/org/hibernate/internal/CriteriaImpl.html
	 */
	property name="nativeCriteria" type="any";

	/**
	 * The entity name this criteria builder is binded to
	 */
	property name="entityName" type="string";

	/**
	 * The bit that determines if we are tracking SQL
	 */
	property
		name   ="sqlLoggerActive"
		type   ="boolean"
		default="false";

	/**
	 * The referenced event manager
	 */
	property name="eventManager" type="any";

	/**
	 * The referenced orm service
	 */
	property name="ormService" type="any";

	/**
	 * If marked as a stream, we will use cbStreams to return to you an array of streams
	 */
	property
		name   ="asStream"
		type   ="boolean"
		default="false";

	/**
	 * The SQL Helper class, great for formatting and tracking SQL
	 */
	property name="sqlHelper" type="any";

	// CFML Criteria Marker, used for distinction between Java and CFML classes
	this.CFML = true;

	/************************************** METHOD ALIASES *********************************************/

	// createAlias() can be used as joinTo()
	this[ "joinTo" ] = variables[ "joinTo" ] = this[ "createAlias" ];

	/************************************** CONSTRUCTOR *********************************************/

	/**
	 * Constructor
	 *
	 * @entityName   The entity name for the criteria query, this is the root of the `from` clause in SQL
	 * @criteria     The hibernate native criteria object: org.hibernate.Criteria, which can be detached or attached
	 * @restrictions A restrictions back reference
	 * @ormService   A reference back to the calling orm service
	 */
	BaseBuilder function init(
		required string entityName,
		required any criteria,
		required any restrictions,
		required any ormService
	){
		// java projections linkage
		this.projections          = arguments.ormService.buildJavaProxy( "org.hibernate.criterion.Projections" );
		// restrictions linkage: can be Restrictions or Subqueries
		this.restrictions         = arguments.restrictions;
		// hibernate criteria query setup - will be either CriteriaBuilder or DetachedCriteriaBuilder
		variables.nativeCriteria  = arguments.criteria;
		// set entity name
		variables.entityName      = arguments.entityName;
		// Link to orm service
		variables.ormService      = arguments.ormService;
		// Link to system event handler
		variables.eventManager    = arguments.ormService.getORMEventHandler().getEventManager();
		// set sql logger usage
		variables.sqlLoggerActive = false;
		// If the return type will be a stream or not
		variables.asStream        = false;

		// Transformer types
		this.ALIAS_TO_ENTITY_MAP  = nativeCriteria.ALIAS_TO_ENTITY_MAP;
		this.DISTINCT_ROOT_ENTITY = nativeCriteria.DISTINCT_ROOT_ENTITY;
		this.ROOT_ENTITY          = nativeCriteria.ROOT_ENTITY;
		this.ROOT_ALIAS           = nativeCriteria.ROOT_ALIAS;

		// Joins
		this.FULL_JOIN  = nativeCriteria.FULL_JOIN;
		this.INNER_JOIN = nativeCriteria.INNER_JOIN;
		this.LEFT_JOIN  = nativeCriteria.LEFT_JOIN;
		this.PROJECTION = nativeCriteria.PROJECTION;

		return this;
	}

	/**
	 * Lazy load injection of the sql helper
	 *
	 * @return cborm.models.sql.SQLHelper
	 */
	function getSQLHelper(){
		if ( isNull( variables.sqlHelper ) ) {
			variables.sqlHelper = variables.ormService
				.getWireBox()
				.getInstance( "SQLHelper@cborm", { criteriaBuilder : this } );
		}
		return variables.sqlHelper;
	}


	/**
	 * Add an ordering to the result set, you can add as many as you like:
	 *
	 * <pre>
	 * order( "lastName", "desc" )
	 * order( property="fullName", ignoreCase=true )
	 * </pre>
	 *
	 * @property   The name of the property to order on
	 * @sortOrder  The order type: asc or desc, defaults to asc
	 * @ignoreCase Wether to ignore case or not, defaults to false
	 */
	any function order(
		required string property,
		string sortDir     = "asc",
		boolean ignoreCase = false
	){
		var order   = variables.ormService.buildJavaProxy( "org.hibernate.criterion.Order" );
		var orderBy = "";

		// direction
		switch ( uCase( arguments.sortDir ) ) {
			case "DESC":
				orderBy = order.desc( arguments.property );
				break;
			default:
				orderBy = order.asc( arguments.property );
				break;
		}

		// ignore case
		if ( arguments.ignoreCase ) {
			orderBy.ignoreCase();
		}

		// Add it
		nativeCriteria.addOrder( orderBy );

		// process interception
		if ( ORMService.getEventHandling() ) {
			variables.eventManager.announce(
				"onCriteriaBuilderAddition",
				{ "type" : "Order", "criteriaBuilder" : this }
			);
		}

		return this;
	}

	/**
	 * Join an association, assigning an alias to the joined association
	 *
	 * You can also use the following alias method : <code>joinTo()</code>
	 *
	 * @associationName The name of the association property: A dot-separated property path
	 * @alias           The alias to assign to the joined association (for later reference).
	 * @joinType        The hibernate join type to use, by default it uses an inner join. Available as properties: criteria.FULL_JOIN, criteria.INNER_JOIN, criteria.LEFT_JOIN
	 * @withClause      The criterion to be added to the join condition (ON clause)
	 */
	any function createAlias(
		required string associationName,
		required string alias,
		numeric joinType = this.INNER_JOIN,
		any withClause
	){
		var hasJoinType   = !isNull( arguments.joinType );
		var hasWithClause = !isNull( arguments.withClause );

		// create alias with an inner join and a with clause restriction
		if ( hasWithClause ) {
			nativeCriteria.createAlias(
				arguments.associationName,
				arguments.alias,
				arguments.joinType,
				arguments.withClause
			);
			// No with clause
		} else {
			nativeCriteria.createAlias(
				arguments.associationName,
				arguments.alias,
				arguments.joinType
			);
		}

		// announce
		if ( ORMService.getEventHandling() ) {
			variables.eventManager.announce(
				"onCriteriaBuilderAddition",
				{ "type" : "Alias", "criteriaBuilder" : this }
			);
		}

		return this;
	}

	/**
	 * Create a new Criteria, "rooted" at the associated entity and using an Inner Join
	 *
	 * @associationName The name of the association property to root the restrictions with
	 * @alias           The alias to use for this association property on restrictions
	 * @joinType        The hibernate join type to use, by default it uses an inner join. Available as properties: criteria.FULL_JOIN, criteria.INNER_JOIN, criteria.LEFT_JOIN
	 * @withClause      The criteria to use with the join
	 */
	any function createCriteria(
		required string associationName,
		string alias,
		numeric joinType,
		any withClause
	){
		var hasAlias        = structKeyExists( arguments, "alias" );
		var hasJoinType     = structKeyExists( arguments, "joinType" );
		var hasWithClause   = structKeyExists( arguments, "withClause" );
		var defaultJoinType = this.INNER_JOIN;
		// if no alias and only join type, special case
		if ( !hasAlias ) {
			if ( hasJoinType ) {
				nativeCriteria = nativeCriteria.createCriteria( arguments.associationName, arguments.joinType );
				// announce
				if ( ORMService.getEventHandling() ) {
					variables.eventManager.announce(
						"onCriteriaBuilderAddition",
						{
							"type"            : "New Criteria w/Join Type",
							"criteriaBuilder" : this
						}
					);
				}
			}
			// no alias and no join type...simple association
			else {
				nativeCriteria = nativeCriteria.createCriteria( arguments.associationName );
			}
		}
		// otherwise, require alias
		if ( hasAlias ) {
			// if a join type is defined, override defaultJoinType
			if ( hasJoinType ) {
				defaultJoinType = arguments.joinType;
			}
			// if we have a withClause, use full signature
			if ( hasWithClause ) {
				nativeCriteria = nativeCriteria.createCriteria(
					arguments.associationName,
					arguments.alias,
					defaultJoinType,
					arguments.withClause
				);
			}
			// ...otherwise, only assoicationName, alias, joinType
			else {
				nativeCriteria = nativeCriteria.createCriteria(
					arguments.associationName,
					arguments.alias,
					defaultJoinType
				);
			}
		}
		if ( ORMService.getEventHandling() ) {
			variables.eventManager.announce(
				"onCriteriaBuilderAddition",
				{ "type" : "New Criteria", "criteriaBuilder" : this }
			);
		}
		return this;
	}

	/**
	 * Add a restriction to constrain the results to be retrieved
	 *
	 * @criterion A single or array of criterions to add to the criteria
	 */
	BaseBuilder function add( required any criterion ){
		if ( !isArray( arguments.criterion ) ) {
			arguments.criterion = [ arguments.criterion ];
		}

		arguments.criterion.each( function( item ){
			nativeCriteria.add( item );
		} );

		return this;
	}

	/**
	 * Sets a valid hibernate result transformer: org.hibernate.transform.ResultTransform to use on the results
	 *
	 * @resultTransformer a custom result transform or you can use the included ones: criteria.ALIAS_TO_ENTITY_MAP, criteria.DISTINCT_ROOT_ENTITY, criteria.PROJECTION, criteria.ROOT_ENTITY.
	 */
	BaseBuilder function resultTransformer( any resultTransformer ){
		nativeCriteria.setResultTransformer( arguments.resultTransformer );
		return this;
	}

	// Aliases for prettier result transformers //

	/**
	 * Applies a result transformer of DISTINCT_ROOT_ENTITY
	 */
	BaseBuilder function asDistinct(){
		nativeCriteria.setResultTransformer( this.DISTINCT_ROOT_ENTITY );
		return this;
	}

	/**
	 * Applies a result transformer of ALIAS_TO_ENTITY_MAP
	 */
	BaseBuilder function asStruct(){
		nativeCriteria.setResultTransformer( this.ALIAS_TO_ENTITY_MAP );
		return this;
	}

	/**
	 * Get the results as a CBstream
	 */
	BaseBuilder function asStream(){
		variables.asStream = true;
		return this;
	}

	/**
	 * Setup a single or a projection list via native projections class: criteria.projections
	 */
	BaseBuilder function setProjection( any projection ){
		// set projection
		nativeCriteria.setProjection( arguments.projection );

		// announce
		if ( ORMService.getEventHandling() ) {
			variables.eventManager.announce(
				"onCriteriaBuilderAddition",
				{ "type" : "Projection", "criteriaBuilder" : this }
			);
		}

		return this;
	}

	/**
	 * Setup projections for this criteria query, you can pass one or as many projection arguments as you like.
	 * The majority of the arguments take in the property name to do the projection on, which will also use that as the alias for the column
	 * or you can pass an alias after the property name separated by a : Ex: projections(avg="balance:avgBalance")
	 * The alias on the projected value can be referred to in restrictions or orderings.
	 * Please also note that the resulting array locations are done in alphabetical order of the arguments.
	 *
	 * @avg                   The name of the property to avg or a list or array of property names
	 * @count                 The name of the property to count or a list or array of property names
	 * @countDistinct         The name of the property to count distinct or a list or array of property names
	 * @distinct              The name of the property to do a distinct on, this can be a single property name a list or an array of property names
	 * @groupProperty         The name of the property to group by or a list or array of property names
	 * @id                    The projected identifier value
	 * @max                   The name of the property to max or a list or array of property names
	 * @min                   The name of the property to min or a list or array of property names
	 * @property              The name of the property to do a projected value on or a list or array of property names
	 * @rowCount              Do a row count on the criteria
	 * @sum                   The name of the property to sum or a list or array of property names
	 * @sqlProjection         Do a projection based on arbitrary SQL string
	 * @sqlGroupProjection    Do a projection based on arbitrary SQL string, with grouping
	 * @detachedSQLProjection Do a projection based on a DetachedCriteria builder config
	 */
	any function withProjections(
		string avg,
		string count,
		string countDistinct,
		any distinct,
		string groupProperty,
		boolean id,
		string max,
		string min,
		string property,
		boolean rowCount,
		string sum,
		any sqlProjection,
		any sqlGroupProjection,
		any detachedSQLProjection
	){
		// create our projection list
		var projectionList = this.PROJECTIONS.projectionList();
		var excludes       = "id,rowCount,distinct,sqlProjection,sqlGroupProjection,detachedSQLProjection";

		// iterate and add dynamically if the incoming argument exists, man, so much easier if we had closures.
		for ( var pType in arguments ) {
			if ( structKeyExists( arguments, pType ) AND NOT listFindNoCase( excludes, pType ) ) {
				addProjection(
					arguments[ pType ],
					lCase( pType ),
					projectionList
				);
			}
		}

		// id
		if ( structKeyExists( arguments, "id" ) ) {
			projectionList.add( this.PROJECTIONS.id() );
		}

		// rowCount
		if ( structKeyExists( arguments, "rowCount" ) ) {
			projectionList.add( this.PROJECTIONS.rowCount() );
		}

		// distinct
		if ( structKeyExists( arguments, "distinct" ) ) {
			addProjection( arguments.distinct, "property", projectionList );
			projectionList = this.PROJECTIONS.distinct( projectionList );
		}

		// detachedSQLProjection
		if ( structKeyExists( arguments, "detachedSQLProjection" ) ) {
			// allow single or arrary of detachedSQLProjection
			var projectionCollection = !isArray( arguments.detachedSQLProjection ) ? [
				arguments.detachedSQLProjection
			] : arguments.detachedSQLProjection;
			// loop over array of detachedSQLProjections
			for ( var projection in projectionCollection ) {
				projectionList.add( projection.createDetachedSQLProjection() );
			}
		}

		// sqlProjection
		if ( structKeyExists( arguments, "sqlProjection" ) ) {
			// allow for either an array of sqlProjections, or a stand-alone config for one
			var sqlargs = !isArray( arguments.sqlProjection ) ? [ arguments.sqlProjection ] : arguments.sqlProjection;
			// loop over sqlProjections
			for ( var projection in sqlargs ) {
				var projectionArgs = prepareSQLProjection( projection );
				projectionList.add(
					this.PROJECTIONS.sqlProjection(
						projectionArgs.sql,
						projectionArgs.alias,
						projectionArgs.types
					),
					arrayToList( projectionArgs.alias )
				);
			}
		}

		// sqlGroupProjection
		if ( structKeyExists( arguments, "sqlGroupProjection" ) ) {
			// allow for either an array of sqlGroupProjections, or a stand-alone config for one
			var sqlargs = !isArray( arguments.sqlGroupProjection ) ? [ arguments.sqlGroupProjection ] : arguments.sqlGroupProjection;
			// loop over sqlGroupProjections
			for ( var projection in sqlargs ) {
				var projectionArgs = prepareSQLProjection( projection );
				projectionList.add(
					this.PROJECTIONS.sqlGroupProjection(
						projectionArgs.sql,
						projectionArgs.group,
						projectionArgs.alias,
						projectionArgs.types
					),
					arrayToList( projectionArgs.alias )
				);
			}
		}
		// add all the projections
		nativeCriteria.setProjection( projectionList );

		// announce
		if ( ORMService.getEventHandling() ) {
			variables.eventManager.announce(
				"onCriteriaBuilderAddition",
				{ "type" : "Projection", "criteriaBuilder" : this }
			);
		}

		return this;
	}

	/**
	 * Coverts an ID, list of ID's, or array of ID's values to the proper java type
	 * The method returns a coverted array of ID's
	 *
	 * @deprecated Please use idCast() instead
	 */
	any function convertIDValueToJavaType( required id ){
		return idCast( argumentCollection = arguments );
	}

	/**
	 * Convert an Id value to it's Java cast type, this is an alias for `ConvertIdValueToJavaType()`
	 *
	 * @entity The entity name or entity object
	 * @id     The id value to convert
	 */
	any function idCast( required id ){
		arguments.entity = variables.entityName;
		return variables.ormService.idCast( argumentCollection = arguments );
	}

	/**
	 * Coverts a value to the correct javaType for the property passed in
	 * The method returns the value in the proper Java Type
	 *
	 * @deprecated Please use autoCast() instead
	 */
	any function convertValueToJavaType( required propertyName, required value ){
		return autoCast( argumentCollection = arguments );
	}

	/**
	 * Coverts a value to the correct javaType for the property passed in.
	 *
	 * @propertyName The property name
	 * @value        The property value
	 */
	any function autoCast( required propertyName, required value ){
		arguments.entity = variables.entityName;
		return variables.ormService.autoCast( argumentCollection = arguments );
	}

	/**
	 * Return a null value
	 */
	function nullValue(){
		return javacast( "null", "" );
	}

	/**
	 * Returns the SQL string that will be prepared for the criteria object at the time of request
	 *
	 * @returnExecutableSql Whether or not to do query param replacements on returned SQL string
	 * @formatSql           Format the SQL to execute
	 */
	string function getSQL( required boolean returnExecutableSql = false, required boolean formatSql = true ){
		return getSqlHelper().getSQL( argumentCollection = arguments );
	}

	/**
	 * Gets the positional SQL parameter values from the criteria query
	 */
	array function getPositionalSQLParameterValues(){
		return getSqlHelper().getPositionalSQLParameterValues();
	}

	/**
	 * Gets positional SQL parameter types from the criteria query
	 *
	 * @simple Whether to return a simply array or full objects
	 */
	any function getPositionalSQLParameterTypes( required boolean simple = true ){
		return getSqlHelper().getPositionalSQLParameterTypes( argumentCollection = arguments );
	}

	/**
	 * Returns a formatted array of parameter value and types
	 */
	array function getPositionalSQLParameters(){
		return getSqlHelper().getPositionalSQLParameters();
	}

	/**
	 * Retrieves the SQL Log
	 */
	array function getSQLLog(){
		return getSqlHelper().getLog();
	}

	/**
	 * Triggers CriteriaBuilder to start internally logging the state of SQL at each iterative build
	 *
	 * @returnExecutableSql Whether or not to do query param replacements on returned SQL string
	 * @formatSql           Format the SQL to execute
	 */
	BaseBuilder function startSqlLog( boolean returnExecutableSql = false, boolean formatSql = false ){
		getSqlHelper().setReturnExecutableSql( arguments.returnExecutableSql );
		getSqlHelper().setFormatSql( arguments.formatSql );
		variables.sqlLoggerActive = true;
		return this;
	}

	/**
	 * Stops CriteriaBuilder from continuing to internally log the state of SQL
	 */
	BaseBuilder function stopSqlLog(){
		variables.sqlLoggerActive = false;
		return this;
	}

	/**
	 * Allows for one-off sql logging at any point in the process of building up CriteriaBuilder; will log the SQL state at the time of the call
	 *
	 * @label The label to use for the sql log record
	 */
	BaseBuilder function logSQL( required String label ){
		getSqlHelper().log( argumentCollection = arguments );
		return this;
	}

	/**
	 * Returns whether or not CriteriaBuilder is currently configured to log SQL
	 * return Boolean
	 */
	boolean function canLogSql(){
		return variables.sqlLoggerActive;
	}

	/**
	 * Peek into the criteria build process with your own closure that accepts the criteria itself.
	 * You can use this for logging, auditing, etc for that moment in time.
	 *
	 * <pre>
	 * newCriteria()
	 * .eq( "this", value )
	 * .peek( (criteria) => {
	 * systemOutput( "CurrentSQL: #criteria.getSQLLog()#" )
	 * })
	 * .list()
	 * </pre>
	 *
	 * @target The closure to peek into, it receives the current criteria as the argument
	 */
	BaseBuilder function peek( required target ){
		arguments.target( this );
		return this;
	}

	/**
	 * A nice functional method to allow you to pass a boolean evaulation and if true,
	 * the target closure will be executed for you, which will pass in the criteria object to it.
	 *
	 * <pre>
	 * newCriteria()
	 * .when( isBoolean( arguments.isPublished ), function( c ){
	 * // Published bit
	 * c.isEq( "isPublished", isPublished );
	 * // Published eq true evaluate other params
	 * if( isPublished ){
	 * c.isLt( "publishedDate", now() )
	 * .$or( c.restrictions.isNull( "expireDate" ), c.restrictions.isGT( "expireDate", now() ) )
	 * .isEq( "passwordProtection","" );
	 * }
	 * } )
	 * .when( !isNull( arguments.showInSearch ), function( criteria ){
	 * c.isEq( "showInSearch", showInSearch );
	 * } )
	 * .list()
	 * </pre>
	 *
	 * @test   The boolean evaluation
	 * @target The closure to execute if test is true, it receives the current criteria as the argument
	 */
	BaseBuilder function when( required boolean test, required target ){
		if ( arguments.test ) {
			arguments.target( this );
		}
		return this;
	}

	/************************************** PRIVATE *********************************************/

	/**
	 * Checks whether or not a projection is currently applied to the CriteriaBuilder
	 */
	private boolean function hasProjection(){
		if ( !isNull( nativeCriteria.getProjection() ) ) {
			return nativeCriteria.getProjection().getLength() ? true : false;
		}
		return false;
	}

	/**
	 * Internal helper to add projections into the projection list
	 *
	 * @propertyName   The property name or an array of property names
	 * @projectionType The projection type to execute on the projection list, comes from here org.hibernate.criterion.Projections
	 * @projectionList The projection list: org.hibernate.criterion.ProjectionList
	 */
	private BaseBuilder function addProjection(
		any propertyName,
		any projectionType,
		any projectionList
	){
		// inflate to array
		if ( isSimpleValue( arguments.propertyName ) ) {
			arguments.propertyName = listToArray( arguments.propertyName );
		}

		// iterate array and add projections
		for ( var thisP in arguments.propertyName ) {
			// add projection into the projection list
			arguments.projectionList.add(
				// projection
				invoke(
					this.PROJECTIONS,
					arguments.projectionType,
					[ listFirst( thisP, ":" ) ]
				),
				// Alias
				listLast( thisP, ":" )
			);

			// announce
			if ( ORMService.getEventHandling() ) {
				variables.eventManager.announce(
					"onCriteriaBuilderAddition",
					{ "type" : "Projection", "criteriaBuilder" : this }
				);
			}
		}

		return this;
	}

	/**
	 * Helper method to prepare sqlProjection for addition to CriteriaBuilder
	 *
	 * @rawProjection The raw projection configuration: { property:1 or list, sql, alias, group }
	 */
	private struct function prepareSQLProjection( struct rawProjection ){
		var orm      = variables.ormService.getORM();
		// get metadata for current root entity
		var metaData = orm
			.getSessionFactory( orm.getEntityDatasource( this.getentityName() ) )
			.getClassMetaData( this.getentityName() );

		// establish projection struct
		var projection       = {};
		// create empty array for propertyTypes
		var projection.types = [];

		// retrieve correct type for each specified property so list() doesn't bork
		for ( var prop in listToArray( arguments.rawProjection.property ) ) {
			arrayAppend( projection.types, metaData.getPropertyType( prop ) );
		}

		var partialSQL = "";
		projection.sql = "";
		// if multiple subqueries have been specified, smartly separate them out into a sql string that will work
		if ( listLen( arguments.rawProjection.sql ) > 1 && listLen( arguments.rawProjection.alias ) > 1 ) {
			for ( var x = 1; x <= listLen( arguments.rawProjection.sql ); x++ ) {
				partialSQL     = listGetAt( arguments.rawProjection.sql, x );
				partialSQL     = reFindNoCase( "^select", partialSQL ) ? "(#partialSQL#)" : partialSQL;
				partialSQL     = partialSQL & " as #listGetAt( arguments.rawProjection.alias, x )#";
				projection.sql = listAppend( projection.sql, partialSQL );
			}
		} else {
			partialSQL     = arguments.rawProjection.sql;
			partialSQL     = partialSQL & " as #arguments.rawProjection.alias#";
			projection.sql = listAppend( projection.sql, partialSQL );
		}

		// get all aliases
		projection.alias = listToArray( arguments.rawProjection.alias );
		// if there is a grouping spcified, add it to structure
		if ( structKeyExists( arguments.rawProjection, "group" ) ) {
			projection.group = arguments.rawProjection.group;
		}
		return projection;
	}

	/**
	 * Normalize Sort orders
	 *
	 * @sortOrder  An HQL Sorting string: fname, lname desc
	 * @ignoreCase Ignoring case or not
	 */
	private void function normalizeOrder( required string sortOrder, required boolean ignoreCase ){
		listToArray( arguments.sortOrder ).each( function( thisSort ){
			var sortField = trim( listFirst( thisSort, " " ) );
			var sortDir   = "ASC";
			if ( listLen( thisSort, " " ) GTE 2 ) {
				sortDir = listGetAt( thisSort, 2, " " );
			}
			// add it to our ordering
			this.order( sortField, sortDir, ignoreCase );
		} );
	}

	/**
	 * creates either a new criteria query, or a new restriction, and returns the result
	 * This is a helper used by concrete on missing methods
	 */
	private any function createRestriction(
		required string missingMethodName,
		required struct missingMethodArguments
	){
		// check for with{associationName} dynamic finder:
		if ( left( arguments.missingMethodName, 4 ) eq "with" ) {
			var args = {
				associationName : right( arguments.missingMethodName, len( arguments.missingMethodName ) - 4 )
			};
			// join type
			if ( structKeyExists( arguments.missingMethodArguments, "1" ) ) {
				args.joinType = arguments.missingMethodArguments[ 1 ];
			}
			if ( structKeyExists( arguments.missingMethodArguments, "joinType" ) ) {
				args.joinType = arguments.missingMethodArguments.joinType;
			}
			// create the dynamic criteria
			return createCriteria( argumentCollection = args );
		}

		// funnel missing methods to restrictions and append to criterias
		return invoke(
			this.restrictions,
			arguments.missingMethodName,
			arguments.missingMethodArguments
		);
	}

}

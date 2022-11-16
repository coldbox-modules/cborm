/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This is the ColdBox Criteria Builder Class that helps you create a nice programmatic
 * DSL language for building hibernate criteria queries and projections without the added
 * complexities.
 *
 * Please see `org.hibernate.Criteria` https://docs.jboss.org/hibernate/orm/5.2/javadocs/org/hibernate/internal/CriteriaImpl.html
 * Nice tutorial on criteria queries: https://howtodoinjava.com/hibernate/hibernate-criteria-queries-tutorial/
 *
 * We also setup several public properties for convenience usage which is inherited from the BaseBuilder
 *
 * <code>this.PROJECTIONS</code> - Maps to the Hibernate projections class: org.hibernate.criterion.Projections</code>
 * <code>this.RESTRICTIONS</code> - Maps to our ColdBox restrictions class: <code>cborm.models.criterion.Restrictions</code>
 *
 * <strong>Join Types</strong>
 * <code>this.FULL_JOIN</code> - Specifies joining to an entity based on a full join.
 * <code>this.INNER_JOIN</code> - Specifies joining to an entity based on an inner join.
 * <code>this.LEFT_JOIN</code> - Specifies joining to an entity based on a left outer join.
 *
 * <strong>Result Transformers</strong>
 * <code>this.ALIAS_TO_ENTITY_MAP</code> -	Each row of results is a Map from alias to entity instance
 * <code>this.DISTINCT_ROOT_ENTITY</code> - Each row of results is a distinct instance of the root entity
 * <code>this.PROJECTION</code> - This result transformer is selected implicitly by calling setProjection()
 * <code>this.ROOT_ENTITY</code> - Each row of results is an instance of the root entity
 *
 */
import cborm.models.*;
component accessors="true" extends="cborm.models.criterion.BaseBuilder" {

	/**
	 * The criteria values this criteria builder builds upon. This is then passed to be evaluated.
	 */
	property name="criterias" type="array";

	/**
	 * The queryCacheRegion name property for all queries in this criteria object
	 */
	property
		name   ="queryCacheRegion"
		type   ="string"
		default="criterias.{entityName}";

	/**
	 * The bit that tells the service to enable query caching, disabled by default
	 */
	property
		name   ="useQueryCaching"
		type   ="boolean"
		default="false";

	/************************************** Constructor *********************************************/

	/**
	 * Constructor
	 *
	 * @entityName       The entity name for the criteria query
	 * @useQueryCaching  Use query caching, defaults to false
	 * @queryCacheRegion The name of the region, defaults to <code>criterias.{entityName}</code>
	 * @ormService       A reference back to the calling orm service
	 * @datasource       The datasource to bind the builder on
	 */
	CriteriaBuilder function init(
		required string entityName,
		boolean useQueryCaching = false,
		string queryCacheRegion = "",
		required any ormService,
		string datasource
	){
		// Determine datasource for given entityName
		var orm = arguments.ormService.getOrm();

		// If no datasource, default it
		if ( isNull( arguments.datasource ) ) {
			arguments.datasource = orm.getEntityDatasource( arguments.entityName );
		}

		// setup basebuilder with criteria query and restrictions
		super.init(
			entityName   = arguments.entityName,
			criteria     = orm.getSession( arguments.datasource ).createCriteria( arguments.entityName ),
			restrictions = arguments.ormService.getRestrictions(),
			ormService   = arguments.ormService
		);

		// local criterion values
		variables.criterias       = [];
		// caching?
		variables.useQueryCaching = arguments.useQueryCaching;

		// caching region?
		if ( len( trim( arguments.queryCacheRegion ) ) EQ 0 ) {
			arguments.queryCacheRegion = "criterias.#arguments.entityName#";
		}
		variables.queryCacheRegion = arguments.queryCacheRegion;

		return this;
	}

	/************************************** PUBLIC *********************************************/

	/**
	 * Execute the criteria queries you have defined and return the results, you can pass optional parameters or define them via our methods
	 *
	 * @offset     The pagination offset, defaults to 0
	 * @max        The max number of records to get, defaults to all
	 * @timeout    The query timeout
	 * @sortOrder  The sorting order
	 * @ignoreCase For the sorting and SQL
	 * @asQuery    Return a query or array of data (objects/struct), defaults to arrays
	 * @asStream   Return a cbStream of array data, defaults to the `asStream` property
	 */
	any function list(
		numeric offset     = 0,
		numeric max        = 0,
		numeric timeout    = 0,
		string  sortOrder  = "",
		boolean ignoreCase = false,
		boolean asQuery    = false,
		boolean asStream   = getAsStream()
	){
		// Setup listing options
		if ( arguments.offset NEQ 0 ) {
			firstResult( arguments.offset );
		}
		if ( arguments.max GT 0 ) {
			maxResults( arguments.max );
		}
		if ( arguments.timeout NEQ 0 ) {
			this.timeout( arguments.timeout );
		}

		// Caching
		if ( getUseQueryCaching() ) {
			cache( true, getQueryCacheRegion() );
		}

		// Sort Order
		if ( len( trim( arguments.sortOrder ) ) ) {
			normalizeOrder( arguments.sortOrder, arguments.ignoreCase );
		}

		// process interception
		if ( variables.ORMService.getEventHandling() ) {
			variables.eventManager.announce( "beforeCriteriaBuilderList", { "criteriaBuilder" : this } );
		}

		// Get listing
		var results = variables.nativeCriteria.list() ?: [];

		// process interception
		if ( variables.ORMService.getEventHandling() ) {
			variables.eventManager.announce(
				"afterCriteriaBuilderList",
				{ "criteriaBuilder" : this, "results" : results }
			);
		}

		// Query?
		if ( arguments.asQuery ) {
			results = entityToQuery( results );
		}

		// Stream?
		if ( arguments.asStream ) {
			return variables.ormService
				.getWireBox()
				.getInstance( "StreamBuilder@cbStreams" )
				.new( results );
		}

		return results;
	}

	/**
	 * pass off arguments to higher-level restriction builder, and handle the results
	 *
	 * @missingMethodName
	 * @missingMethodArguments
	 */
	any function onMissingMethod( required string missingMethodName, required struct missingMethodArguments ){
		// get the restriction/new criteria
		var thisRestriction = createRestriction( argumentCollection = arguments );

		// switch on the object type
		if ( structKeyExists( thisRestriction, "CFML" ) ) {
			// if it's a builder, just return this, it has been added already
			return this;
		}

		// Else, it's a native Java restriction, add it in
		variables.nativeCriteria.add( thisRestriction );

		// process interception
		if ( variables.ORMService.getEventHandling() ) {
			variables.eventManager.announce(
				"onCriteriaBuilderAddition",
				{ "type" : "Restriction", "criteriaBuilder" : this }
			);
		}

		return this;
	}

	/**
	 * Create an instance of a detached criteriabuilder that can be added, like criteria, to the main criteria builder
	 *
	 * @entityName The entity to root the subcriteria on
	 * @alias      The alias to use or defaults to the entity name
	 *
	 * @return DetachedCriteriaBuilder
	 */
	any function createSubcriteria( required string entityName, string alias = "" ){
		// create detached builder
		arguments.ormService = variables.ormService;
		var subcriteria      = variables.ormService
			.getWireBox()
			.getInstance( "DetachedCriteriaBuilder@cborm", arguments );

		// process interception
		if ( variables.ORMService.getEventHandling() ) {
			variables.eventManager.announce(
				"onCriteriaBuilderAddition",
				{ "type" : "Subquery", "criteriaBuilder" : this }
			);
		}

		// return the subscriteria instance so we can keep chaining methods to it, but rooted to the subcriteria
		return subcriteria;
	}

	/**
	 * Enable caching of this query result, provided query caching is enabled for the underlying session factory.
	 *
	 * @cache       Cache or not
	 * @cacheRegion The cache region
	 */
	any function cache( required boolean cache = true, string cacheRegion ){
		variables.nativeCriteria.setCacheable( javacast( "boolean", arguments.cache ) );
		if ( !isNull( arguments.cacheRegion ) ) {
			variables.nativeCriteria.setCacheRegion( arguments.cacheRegion );
		}
		return this;
	}

	/**
	 * Set the name of the cache region to use for query result caching.
	 *
	 * @cacheRegion
	 */
	any function cacheRegion( required string cacheRegion ){
		variables.nativeCriteria.setCacheRegion( arguments.cacheRegion );
		return this;
	}

	/**
	 * Add a comment to the generated SQL.
	 *
	 * @comment a human-readable string
	 */
	any function comment( required string comment ){
		variables.nativeCriteria.setComment( arguments.comment );
		return this;
	}

	/**
	 * Set a fetch size for the underlying JDBC query.
	 *
	 * @fetchSize An integer number
	 */
	any function fetchSize( required numeric fetchSize ){
		variables.nativeCriteria.setFetchSize( javacast( "int", arguments.fetchSize ) );
		return this;
	}

	/**
	 * Set the first result to be retrieved or the offset integer
	 *
	 * @firstResult Which offset to set
	 */
	any function firstResult( required numeric firstResult ){
		variables.nativeCriteria.setFirstResult( javacast( "int", arguments.firstResult ) );
		if ( getSqlHelper().canLogLimitOffset() ) {
			// process interception
			if ( variables.ORMService.getEventHandling() ) {
				variables.eventManager.announce(
					"onCriteriaBuilderAddition",
					{ "type" : "Offset", "criteriaBuilder" : this }
				);
			}
		}
		return this;
	}

	/**
	 * Set a limit upon the number of objects to be retrieved.
	 *
	 * @maxResults The max results to retrieve
	 */
	any function maxResults( required numeric maxResults ){
		variables.nativeCriteria.setMaxResults( javacast( "int", arguments.maxResults ) );
		if ( getSqlHelper().canLogLimitOffset() ) {
			// process interception
			if ( variables.ORMService.getEventHandling() ) {
				variables.eventManager.announce(
					"onCriteriaBuilderAddition",
					{ "type" : "Max", "criteriaBuilder" : this }
				);
			}
		}
		return this;
	}

	/**
	 * Set the read-only/modifiable mode for entities and proxies loaded by this Criteria, defaults to readOnly=true
	 *
	 * @readOnly Read only or full entities, defaults to true
	 */
	any function readOnly( boolean readOnly = true ){
		variables.nativeCriteria.setReadOnly( javacast( "boolean", arguments.readOnly ) );
		return this;
	}

	/**
	 * Set a timeout for the underlying JDBC query in milliseconds
	 *
	 * @timeout The timeout value to apply in milliseconds
	 */
	any function timeout( required numeric timeout ){
		variables.nativeCriteria.setTimeout( javacast( "int", arguments.timeout ) );
		return this;
	}

	/**
	 * Add a DB query hint to the SQL. These differ from JPA's QueryHint, which is specific to the JPA implementation and ignores DB vendor-specific hints. Instead, these are intended solely for the vendor-specific hints, such as Oracle's optimizers. Multiple query hints are supported; the Dialect will determine concatenation and placement.
	 *
	 * @string The vendoer specific query hint
	 */
	any function queryHint( string hint ){
		variables.nativeCriteria.addQueryHint( arguments.hint );
		return this;
	}

	/**
	 * Convenience method to return a single instance that matches the built up criterias query, or throws an exception if the query returns no results
	 *
	 * @properties An optional list of properties to retrieve instead of the entire object
	 *
	 * @return The requested entity or if using properties, the properties requested as a struct
	 *
	 * @throws EntityNotFound           - When no entity was found for the specific criteria
	 * @throws NonUniqueResultException - When more than one result is found with the specific criteria
	 */
	any function getOrFail( properties = "" ){
		var result = this.get( arguments.properties );
		if ( isNull( result ) ) {
			throw( message = "No entity found for the specific criteria", type = "EntityNotFound" );
		}
		return result;
	}

	/**
	 * Convenience method to return a single instance that matches the built up criterias query, or null if the query returns no results.
	 *
	 * @properties An optional list of properties to retrieve instead of the entire object
	 *
	 * @return The requested entity or if using properties, the properties requested as a struct
	 *
	 * @throws NonUniqueResultException - if there is more than one matching result
	 */
	any function get( properties = "" ){
		// process interception
		if ( variables.ORMService.getEventHandling() ) {
			variables.eventManager.announce( "beforeCriteriaBuilderGet", { "criteriaBuilder" : this } );
		}

		// Do we have any properties to add?
		if ( len( arguments.properties ) ) {
			withProjections( property = arguments.properties ).asStruct();
		}

		// Go fetch!
		var result = variables.nativeCriteria.uniqueResult();

		// process interception
		if ( !isNull( result ) && variables.ORMService.getEventHandling() ) {
			variables.eventManager.announce(
				"afterCriteriaBuilderGet",
				{ "criteriaBuilder" : this, "result" : result }
			);
		}

		if ( !isNull( result ) ) {
			return result;
		}
	}

	/**
	 * Get the record count using hibernate projections for the given criterias
	 *
	 * @propertyName The name of the property to do the count on or do it for all row results instead
	 */
	numeric function count( propertyName = "" ){
		// process interception
		if ( variables.ORMService.getEventHandling() ) {
			variables.eventManager.announce( "beforeCriteriaBuilderCount", { "criteriaBuilder" : this } );
		}

		// else project on the local criterias
		if ( len( arguments.propertyName ) ) {
			variables.nativeCriteria.setProjection( this.projections.countDistinct( arguments.propertyName ) );
		} else {
			variables.nativeCriteria.setProjection( this.projections.distinct( this.projections.rowCount() ) );
		}

		// process interception
		if ( variables.ORMService.getEventHandling() ) {
			variables.eventManager.announce(
				"onCriteriaBuilderAddition",
				{ "type" : "Count", "criteriaBuilder" : this }
			);
		}

		var results = variables.nativeCriteria.uniqueResult();
		// clear count like a ninja, so we can reuse this criteria object.
		variables.nativeCriteria.setProjection( javacast( "null", "" ) );
		variables.nativeCriteria.setResultTransformer( this.ROOT_ENTITY );

		// process interception
		if ( variables.ORMService.getEventHandling() ) {
			variables.eventManager.announce(
				"afterCriteriaBuilderCount",
				{ "criteriaBuilder" : this, "results" : results }
			);
		}

		return results;
	}

	/************************************** PRIVATE *********************************************/

}

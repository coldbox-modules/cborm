/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This is a helper ORM service that will help you abstract some complexities
 * when dealing with CF's ORM via Hibernate.  You can use this service in its
 * concrete form or you can inherit from it and extend it.
 */
import cborm.models.util.*;

component accessors="true" {

	/**
	 * The name of the cache region to store cached queries, entities, etc.  Defaults to `ORMService.defaultCache`
	 */
	property
		name      ="queryCacheRegion"
		type      ="string"
		default   ="ORMService.defaultCache"
		persistent="false";

	/**
	 * Tells the services to leverage query caching, defaults to false
	 */
	property
		name      ="useQueryCaching"
		type      ="boolean"
		default   ="false"
		persistent="false";

	/**
	 * Bit identifying if ORM event handling is active, defaults to true
	 */
	property
		name      ="eventHandling"
		type      ="boolean"
		default   ="true"
		persistent="false";

	/**
	 * The system ORM event handler to transmit ORM events to.
	 */
	property name="ORMEventHandler" persistent="false";

	/**
	 * The system ORM utility object depending on the CFML Engine you are on.
	 */
	property name="ORM" persistent="false";

	/**
	 * The bit that enables automatic transaction demarcation on all save, saveAll, update, delete methods, default is TRUE
	 */
	property
		name      ="useTransactions"
		type      ="boolean"
		default   ="true"
		persistent="false";

	/**
	 * The bit that determines the default return value for list(), createCriteria() and executeQuery() as query or arrays, default is query for listing
	 */
	property
		name      ="defaultAsQuery"
		type      ="boolean"
		default   ="false"
		persistent="false";

	/**
	 * The default datsource to use for all transactions, else we look at arguments or entity itself
	 */
	property
		name      ="datasource"
		type      ="string"
		persistent="false"
		default   ="";

	/**
	 * A LogBox logger prepared for the class
	 */
	property name="logger" persistent="false";

	/**
	 * A WireBox reference
	 */
	property name="wirebox" persistent="false";


	/************************************** CONSTRUCTOR *********************************************/

	/**
	 * Constructor
	 *
	 * @queryCacheRegion The default query cache region to use, by default it uses ORMService.defaultCache
	 * @useQueryCaching  Activate caching or not
	 * @eventHandling    Activate event handling or not
	 * @useTransactions  Use cftransactions around all crud operations or not
	 * @defaultAsQuery   Return queries or array of objects by default
	 * @datasource       The default datasource to use for this service
	 */
	BaseORMService function init(
		string queryCacheRegion = "ORMService.defaultCache",
		boolean useQueryCaching = false,
		boolean eventHandling   = true,
		boolean useTransactions = true,
		boolean defaultAsQuery  = false,
		string datasource
	){
		// setup local properties
		variables.queryCacheRegion = arguments.queryCacheRegion;
		variables.useQueryCaching  = arguments.useQueryCaching;
		variables.eventHandling    = arguments.eventHandling;
		variables.useTransactions  = arguments.useTransactions;
		variables.defaultAsQuery   = arguments.defaultAsQuery;
		// We go out to app scope due to the ORM loading at application startup time.
		// This is on purpose
		variables.wirebox          = application.wirebox;
		variables.logger           = variables.wirebox.getLogBox().getLogger( this );

		// Datasource
		if ( isNull( arguments.datasource ) ) {
			var appMD = getApplicationMetadata();
			if ( appMD.keyExists( "ormsettings" ) && appMD.ormsettings.keyExists( "datasource" ) ) {
				variables.datasource = appMD.ormsettings.datasource;
			} else {
				variables.datasource = appMD.datasource;
			}
		} else {
			variables.datasource = arguments.datasource;
		}

		return this;
	}

	/*****************************************************************************************/
	/************************************ UTILITY METHODS ************************************/
	/*****************************************************************************************/

	/**
	 * Functional construct for if statements operating over this service and family of services
	 *
	 * The success/failure closures accept the entity in question as the first argument
	 * <pre>
	 * when( true|false, ( entity )=> {}, ( entity )=> {} )
	 * </pre>
	 *
	 * @target  The boolean evaluator, it has to evaluate to true or false
	 * @success The closure/lambda to execute if the boolean value is true
	 * @failure The closure/lambda to execute if the boolean value is false
	 *
	 * @return Returns the same object so you can further use chaining
	 */
	BaseORMService function when(
		required boolean target,
		required success,
		failure
	){
		if ( arguments.target ) {
			arguments.success( this );
		} else if ( !isNull( arguments.failure ) ) {
			arguments.failure( this );
		}
		return this;
	}

	/**
	 * Lazy loading of the ORM utility according to the CFML engine you are on
	 * - LuceeORMUtil : For Lucee Engines
	 * - CFORMUtil : For Adobe Engines
	 *
	 * @return cborm.models.util.IORMUtil
	 */
	function getOrm(){
		if ( isNull( variables.orm ) ) {
			variables.orm = new cborm.models.util.ORMUtilFactory().getORMUtil();
		}
		return variables.orm;
	}

	/**
	 * Lazy loading event handler for performance
	 *
	 * @return cborm.models.EventHandler
	 */
	function getORMEventHandler(){
		if ( isNull( variables.ORMEventHandler ) ) {
			variables.ORMEventHandler = new cborm.models.EventHandler();
		}
		return variables.ORMEventHandler;
	}

	/**
	 * Lazy loading the dynamic methods processor
	 *
	 * @return cborm.models.util.DynamicProcessor
	 */
	function getDynamicProcessor(){
		if ( isNull( variables.dynamicProcessor ) ) {
			variables.dynamicProcessor = variables.wirebox.getInstance( "cborm.models.util.DynamicProcessor" );
		}

		return variables.dynamicProcessor;
	}

	/**
	 * Convert an Id value to it's Java cast type, this is an alias for `ConvertIdValueToJavaType()`
	 *
	 * @entity The entity name or entity object
	 * @id     The id value to convert
	 */
	any function idCast( required entity, required id ){
		var hibernateMD = getEntityMetadata( arguments.entity );

		// No component type support for identifiers
		if ( !isNull( hibernateMD ) and !hibernateMD.getIdentifierType().isComponentType() ) {
			var identifierType = hibernateMD.getIdentifierType();

			// id conversion to array
			if ( isSimpleValue( arguments.id ) ) {
				arguments.id = listToArray( arguments.id );
			}

			// Convert to Java Type
			return arguments.id.map( function( thisID ){
				return identifierType.fromStringValue( thisID );
			} );
		}

		return arguments.id;
	}

	/**
	 * Coverts a value to the correct javaType for the property passed in.
	 *
	 * @entity       The entity name or entity object
	 * @propertyName The property name
	 * @value        The property value
	 */
	any function autoCast(
		required entity,
		required propertyName,
		required value
	){
		var hibernateMD = getEntityMetadata( arguments.entity );

		return hibernateMD.getPropertyType( arguments.propertyName ).fromStringValue( arguments.value );
	}

	/**
	 * Coverts an ID, list of ID's, or array of ID's values to the proper Java type
	 * The method returns a coverted array of ID's
	 *
	 * @deprecated In favor of `idCast()`
	 * @entityName The entity name
	 * @id         The id value to convert
	 */
	any function convertIdValueToJavaType( required entityName, required id ){
		arguments.entity = arguments.entityname;
		return idCast( argumentCollection = arguments );
	}

	/**
	 * Coverts a value to the correct javaType for the property passed in
	 *
	 * @deprecated   In favor of `autoCast()`
	 * @entityName   The entity name or entity object
	 * @propertyName The property name
	 * @value        The property value
	 */
	any function convertValueToJavaType(
		required entityName,
		required propertyName,
		required value
	){
		arguments.entity = arguments.entityName;
		return autoCast( argumentCollection = arguments );
	}

	/*****************************************************************************************/
	/************************************ RETRIEVAL METHODS **********************************/
	/*****************************************************************************************/

	/**
	 * List all of the instances of the passed in entity class name. You can pass in several optional arguments like
	 * a struct of filtering criteria, a sortOrder string, offset, max, ignorecase, and timeout.
	 *
	 * Caching for the list is based on the useQueryCaching class property and the cachename property is based on
	 * the queryCacheRegion class property.
	 *
	 * @entityName The entity to list on
	 * @criteria   A struct of filtering criteria to apply to the where clause
	 * @sortOrder  The sorting order of the result
	 * @offset     Used for pagination
	 * @max        The max number of records to retrieve
	 * @timeout    A DB timeout for this query
	 * @ignoreCase Case insensitive or case sensitive searches, we default to case sensitive filtering.
	 * @asQuery    The return format as either a query or array of objects
	 * @asStream   The return format will be a cbStream
	 */
	any function list(
		required string entityName,
		struct criteria    = structNew(),
		string sortOrder   = "",
		numeric offset     = 0,
		numeric max        = 0,
		numeric timeout    = 0,
		boolean ignoreCase = false,
		boolean asQuery    = getDefaultAsQuery(),
		boolean asStream   = false
	){
		var options = {};

		// Setup listing options
		if ( arguments.offset neq 0 ) {
			options.offset = arguments.offset;
		}
		if ( arguments.max neq 0 ) {
			options.maxresults = arguments.max;
		}
		if ( arguments.timeout neq 0 ) {
			options.timeout = arguments.timeout;
		}

		// Caching?
		if ( getUseQueryCaching() ) {
			options.cacheName = getQueryCacheRegion();
			options.cacheable = true;
		}

		// Sort Order Case
		if ( len( trim( arguments.sortOrder ) ) ) {
			options.ignoreCase = arguments.ignoreCase;
		}

		// Execute Query: https://cfdocs.org/entityload
		var results = entityLoad(
			arguments.entityName,
			arguments.criteria,
			arguments.sortOrder,
			options
		);

		// Is it Null?
		if ( isNull( results ) ) {
			results = [];
		}


		// As Stream or Query
		if ( arguments.asStream ) {
			return variables.wirebox.getInstance( "StreamBuilder@cbStreams" ).new( results );
		} else if ( arguments.asQuery ) {
			return entityToQuery( results );
		}

		return results;
	}

	/**
	 * Allows the execution of HQL queries using several nice arguments and returns either an array of entities or a query as specified by the asQuery argument.
	 * The params filtering can be using named or positional.
	 *
	 * @query      The HQL Query to execute
	 * @params     A struct or array of query params
	 * @offset     Used for pagination
	 * @max        The max number of records to retrieve
	 * @timeout    A DB timeout for this query
	 * @ignoreCase Case insensitive or case sensitive searches, we default to case sensitive filtering.
	 * @asQuery    The return format as either a query or array of objects
	 * @unique     Return array or a unique record, defaults to array
	 * @datasource The datasource to use
	 * @asStream   The return format will be a cbStream
	 */
	any function executeQuery(
		required string query,
		any params         = structNew(),
		numeric offset     = 0,
		numeric max        = 0,
		numeric timeout    = 0,
		boolean ignorecase = false,
		boolean asQuery    = getDefaultAsQuery(),
		boolean unique     = false,
		string datasource  = "",
		boolean asStream   = false
	){
		var options = {};

		// Setup listing options
		if ( arguments.offset neq 0 ) {
			options.offset = arguments.offset;
		}
		if ( arguments.max neq 0 ) {
			options.maxresults = arguments.max;
		}
		if ( arguments.timeout neq 0 ) {
			options.timeout = arguments.timeout;
		}
		if ( len( arguments.datasource ) ) {
			options.datasource = arguments.datasource;
		} else {
			options.datasource = getDatasource();
		}
		options.ignorecase = arguments.ignorecase;

		// Caching?
		if ( getUseQueryCaching() ) {
			options.cacheName = getQueryCacheRegion();
			options.cacheable = true;
		}

		// process interception
		if ( getEventHandling() ) {
			getORMEventHandler()
				.getEventManager()
				.announce(
					"beforeOrmExecuteQuery",
					{
						"query"   : arguments.query,
						"params"  : arguments.params,
						"unique"  : arguments.unique,
						"options" : options
					}
				);
		}

		// Get listing: https://cfdocs.org/ormexecutequery
		var results = ormExecuteQuery(
			arguments.query,
			arguments.params,
			arguments.unique,
			options
		);

		// process interception
		if ( getEventHandling() ) {
			getORMEventHandler()
				.getEventManager()
				.announce(
					"afterOrmExecuteQuery",
					{
						"query"   : arguments.query,
						"params"  : arguments.params,
						"unique"  : arguments.unique,
						"options" : options,
						"results" : isNull( results ) ? javacast( "null", "" ) : results
					}
				);
		}

		// Null Checks
		if ( isNull( results ) ) {
			if ( arguments.asStream ) {
				return variables.wirebox.getInstance( "StreamBuilder@cbStreams" ).new();
			} else if ( arguments.asQuery ) {
				return queryNew( "" );
			}

			if ( arguments.unique ) {
				return; // NULL
			} else {
				return [];
			}
		}

		// Determine if we are in a UPDATE, INSERT or DELETE, if we do, just return the results, it is a numeric
		if ( reFindNoCase( "(delete|insert|update)\s", arguments.query ) ) {
			return results;
		}

		// As Stream or Query
		if ( arguments.asStream ) {
			return variables.wirebox.getInstance( "StreamBuilder@cbStreams" ).new( results );
		} else if ( arguments.asQuery ) {
			return entityToQuery( results );
		}

		return results;
	}

	/**
	 * Get an entity using a primary key, if the id is not found this method throws an EntityNotFound Exception
	 *
	 * @throws EntityNotFound
	 */
	any function getOrFail( required string entityName, required any id ){
		var result = this.get(
			entityName = arguments.entityName,
			id         = arguments.id,
			returnNew  = false
		);
		if ( isNull( result ) ) {
			throw(
				message      = "No entity found for ID #arguments.id.toString()#",
				type         = "EntityNotFound",
				extendedinfo = arguments.entityName
			);
		}
		return result;
	}

	/**
	 * Get an entity using a primary key, if the id is not found this method returns null, if the id=0 or blank it returns a new entity.
	 *
	 * @entityName The name of the entity to retrieve
	 * @id         An optional primary key to use to retrieve the entity, if the id is `0` or `empty` it will return a new unloaded entity
	 * @returnNew  By default if the primary key is 0 or empty it returns a new unloaded entity, if false, then always null
	 *
	 * @return Requested entity, new entity or `null`
	 */
	any function get(
		required string entityName,
		required any id,
		boolean returnNew = true
	){
		// check if id exists so entityLoad does not throw error
		if (
			( isSimpleValue( arguments.id ) and len( arguments.id ) )
			OR
			NOT isSimpleValue( arguments.id )
		) {
			// https://cfdocs.org/entityloadbypk
			var oEntity = entityLoadByPK( arguments.entityName, arguments.id );
			// Check if not null, then return it
			if ( !isNull( oEntity ) ) {
				return oEntity;
			}
		}

		// Check for return new?
		if ( arguments.returnNew ) {
			// Check if ID=0 or empty to do convenience new entity
			if ( isSimpleValue( arguments.id ) and ( arguments.id eq 0 OR len( arguments.id ) eq 0 ) ) {
				return this.new( entityName = arguments.entityName );
			}
		}
	}

	/**
	 * Retrieve all the instances from the passed in entity name using the id argument if specified.flash.inflateFlash()
	 * You can also use the properties argument so this method can return to you array of structs instead of array of objects.
	 * The property list must include the `as` alias if not you will get positional keys.
	 * Example: properties="catID as id, category as category, role as role"
	 *
	 * @entityName The entity to get
	 * @id         The id or a list/array of Ids to retrieve
	 * @sortOrder  The sorting of the returning array, defaults to natural sorting
	 * @readOnly   Return full or read only entities, defaults to false
	 * @properties If passed, you can retrieve an array of properties of the entity instead of the entire entity.  Make sure you add aliases to the properties: Ex: 'catId as id'
	 * @asStream   Return a stream if true
	 */
	any function getAll(
		required string entityName,
		any id,
		string sortOrder = "",
		boolean readOnly = false,
		string properties,
		boolean asStream = false
	){
		var results = [];

		// Prepare HQL, it is way faster with HQL
		var hql = "FROM #arguments.entityName#";

		// Properties
		if ( !isNull( arguments.properties ) ) {
			hql = "SELECT new map( #arguments.properties# ) #hql#";
		}

		// ID
		if ( !isNull( arguments.id ) ) {
			// type safe conversions
			arguments.id = convertIDValueToJavaType( entityName = arguments.entityName, id = arguments.id );
			hql &= " WHERE id in (:idlist)";
		}

		// Sorting
		if ( len( arguments.sortOrder ) ) {
			hql &= " ORDER BY #arguments.sortOrder#";
		}

		// Execute native hibernate query
		var query = getOrm().getSession( getOrm().getEntityDatasource( arguments.entityName ) ).createQuery( hql );

		// parameter binding
		if ( !isNull( arguments.id ) ) {
			query.setParameterList( "idlist", arguments.id );
		}

		// Caching?
		if ( getUseQueryCaching() ) {
			query.setCacheRegion( getQueryCacheRegion() );
			query.setCacheable( true );
		}
		// Read Only
		query.setReadOnly( javacast( "boolean", arguments.readOnly ) );

		// Streams Support
		if ( arguments.asStream ) {
			// If Hibernate 5, return native stream: left( getOrm().getHibernateVersion(), 1 ) > 5
			if ( listFirst( server.coldfusion.productVersion ) >= 2018 ) {
				return variables.wirebox
					.getInstance( "StreamBuilder@cbStreams" )
					.new()
					.setJStream( query.stream() );
			} else {
				return variables.wirebox.getInstance( "StreamBuilder@cbStreams" ).new( query.list() );
			}
		}

		// Normal execution
		return query.list();
	}

	/**
	 * Finds and returns the first result for the given query or throws an exception if not found,
	 * this method delegates to the `findIt()` method
	 */
	any function findOrFail(
		required string query,
		any params         = structNew(),
		numeric timeout    = 0,
		boolean ignoreCase = false,
		string datasource  = getDatasource()
	){
		var result = findIt( argumentCollection = arguments );
		if ( isNull( result ) ) {
			throw( message = "No entity found", type = "EntityNotFound" );
		}
		return result;
	}

	/**
	 * Finds and returns the first result for the given query or null if no entity was found.
	 * You can either use the query and params combination
	 *
	 * @query      The HQL Query to execute
	 * @params     A struct or array of query params
	 * @timeout    A DB timeout for this query
	 * @ignoreCase Case insensitive or case sensitive searches, we default to case sensitive filtering.
	 * @datasource The datasource to use
	 */
	any function findIt(
		required string query,
		any params         = structNew(),
		numeric timeout    = 0,
		boolean ignoreCase = false,
		string datasource  = getDatasource()
	){
		// One result
		arguments.max     = 1;
		arguments.unique  = true;
		arguments.asQuery = false;

		// Delegate
		return executeQuery( argumentCollection = arguments );
	}

	/**
	 * Find all/single entities by example
	 *
	 * https://dzone.com/articles/hibernate-query-example-qbe
	 * https://cfdocs.org/entityloadbyexample
	 *
	 * @example The example entity
	 * @unique  Unique or array of entities (default)
	 */
	any function findByExample( any example, boolean unique = false ){
		return entityLoadByExample( arguments.example, arguments.unique );
	}

	/**
	 * Find all entities for the specified HQL query and accompanied params.
	 *
	 * @query      The HQL Query to execute
	 * @params     A struct or array of query params
	 * @offset     Used for pagination
	 * @max        The max number of records to retrieve
	 * @timeout    A DB timeout for this query
	 * @ignoreCase Case insensitive or case sensitive searches, we default to case sensitive filtering.
	 * @datasource The datasource to use
	 * @asStream   Return a stream if true
	 *
	 * @return array of entities or a cbstream
	 */
	any function findAll(
		string query,
		any params         = structNew(),
		numeric offset     = 0,
		numeric max        = 0,
		numeric timeout    = 0,
		boolean ignoreCase = false,
		string datasource,
		boolean asStream = false
	){
		// Normal Execute Query
		arguments.asQuery = false;
		return executeQuery( argumentCollection = arguments );
	}

	/**
	 * Find one entity (or null if not found) according to a criteria structure
	 *
	 * @entityName The entity to search for
	 * @criteria   The filtering criteria to search for.
	 */
	any function findWhere( required string entityName, struct criteria = {} ){
		// Caching?
		if ( getUseQueryCaching() ) {
			// if we are caching, we will use find all and return an array since entityLoad does not support both unique and caching
			var aEntity = findAllWhere( argumentCollection = arguments );
			return ( arrayLen( aEntity ) ? aEntity[ 1 ] : javacast( "null", "" ) );
		} else {
			return entityLoad( arguments.entityName, arguments.criteria, true );
		}
	}

	/**
	 * Find all entities according to criteria structure
	 *
	 * @entityName The entity to search for
	 * @criteria   The filtering criteria to search for.
	 * @sortOrder  The sorting order
	 */
	array function findAllWhere(
		required string entityName,
		struct criteria    = {},
		string sortOrder   = "",
		boolean ignoreCase = false,
		numeric timeout    = 0,
		boolean asStream   = false
	){
		var options = {
			ignorecase : arguments.ignoreCase,
			timeout    : arguments.timeout
		};

		// Caching?
		if ( getUseQueryCaching() ) {
			options.cacheName = getQueryCacheRegion();
			options.cacheable = true;
		}

		var results = entityLoad(
			arguments.entityName,
			arguments.criteria,
			arguments.sortOrder,
			options
		);

		// As stream
		if ( arguments.asStream ) {
			return variables.wirebox.getInstance( "StreamBuilder@cbStreams" ).new( results );
		}

		return results;
	}

	/*****************************************************************************************/
	/************************************ CREATION METHODS ***********************************/
	/*****************************************************************************************/

	/**
	 * Return a null value
	 */
	function nullValue(){
		return javacast( "null", "" );
	}

	/**
	 * Get a new entity object by entity name and you can pass in the properties structre also to bind the entity with properties
	 *
	 * @entityName           The entity to create
	 * @properties           The structure of data to populate the entity with. By default we will inspect for many-to-one, one-to-many and many-to-many relationships and compose them for you.
	 * @composeRelationships Automatically attempt to compose relationships from the incoming properties memento
	 * @nullEmptyInclude     A list of keys to NULL when empty
	 * @nullEmptyExclude     A list of keys to NOT NULL when empty
	 * @ignoreEmpty          Ignore empty values on populations, great for ORM population
	 * @include              A list of keys to include in the population from the incoming properties memento
	 * @exclude              A list of keys to exclude in the population from the incoming properties memento
	 */
	any function new(
		required string entityName,
		struct properties            = structNew(),
		boolean composeRelationships = true,
		nullEmptyInclude             = "",
		nullEmptyExclude             = "",
		boolean ignoreEmpty          = false,
		include                      = "",
		exclude                      = ""
	){
		var eventHandler = getORMEventHandler();
		// Build and autowire
		var entity       = eventHandler.processEntityInjection(
			entityName: arguments.entityName,
			entity    : entityNew( arguments.entityName )
		);

		// Population of properties
		if ( NOT structIsEmpty( arguments.properties ) ) {
			populate(
				target               = entity,
				memento              = arguments.properties,
				composeRelationships = arguments.composeRelationships,
				nullEmptyInclude     = arguments.nullEmptyInclude,
				nullEmptyExclude     = arguments.nullEmptyExclude,
				ignoreEmpty          = arguments.ignoreEmpty,
				include              = arguments.include,
				exclude              = arguments.exclude
			);
		}

		// Event Handling? If enabled, call the postNew() interception
		if ( getEventHandling() ) {
			eventHandler.postNew( entity, arguments.entityName );
		}

		return entity;
	}

	/**
	 * Create a virtual abstract service for a specfic entity
	 *
	 * @entityname       The name of the entity to root this service with
	 * @queryCacheRegion The name of the query cache region if using caching, defaults to `#arguments.entityName#.defaultVSCache`
	 * @useQueryCaching  Activate query caching, defaults to false
	 * @eventHandling    Activate event handling, defaults to true
	 * @useTransactions  Activate transaction blocks on calls, defaults to true
	 * @defaultAsQuery   Return query or array of objects on list(), executeQuery(), criteriaQuery(), defaults to true
	 * @datasource       THe datsource name to be used for the rooted entity, if not we use the default datasource
	 *
	 * @return cborm.models.VirtualEntityService
	 */
	any function createService(
		required string entityname,
		string queryCacheRegion = getQueryCacheRegion(),
		boolean useQueryCaching = getUseQueryCaching(),
		boolean eventHandling   = getEventHandling(),
		boolean useTransactions = getUseTransactions(),
		boolean defaultAsQuery  = getDefaultAsQuery(),
		string datasource       = getDatasource()
	){
		return new cborm.models.VirtualEntityService( argumentCollection = arguments );
	}

	/*****************************************************************************************/
	/********************************* POPULATION METHODS ************************************/
	/*****************************************************************************************/

	/**
	 * Populate/bind an entity's properties and relationships from an incoming structure or map of flat data.
	 *
	 * @target               The entity to populate
	 * @memento              The map/struct to populate the entity with
	 * @scope                Use scope injection instead of setter injection, no need of setters, just tell us what scope to inject to
	 * @trustedSetter        Do not check if the setter exists, just call it, great for usage with onMissingMethod() and virtual properties
	 * @include              A list of keys to include in the population ONLY
	 * @exclude              A list of keys to exclude from the population
	 * @ignoreEmpty          Ignore empty values on populations, great for ORM population
	 * @nullEmptyInclude     A list of keys to NULL when empty
	 * @nullEmptyExclude     A list of keys to NOT NULL when empty
	 * @composeRelationships Automatically attempt to compose relationships from the incoming properties memento
	 */
	any function populate(
		required any target,
		required struct memento,
		string scope                 = "",
		boolean trustedSetter        = false,
		string include               = "",
		string exclude               = "",
		boolean ignoreEmpty          = false,
		string nullEmptyInclude      = "",
		string nullEmptyExclude      = "",
		boolean composeRelationships = true
	){
		return getObjectPopulator().populateFromStruct( argumentCollection = arguments );
	}

	/**
	 * Simple map to property population for entities with structure key prefixes
	 *
	 * @target               The entity to populate
	 * @memento              The map/struct to populate the entity with
	 * @scope                Use scope injection instead of setter injection, no need of setters, just tell us what scope to inject to
	 * @trustedSetter        Do not check if the setter exists, just call it, great for usage with onMissingMethod() and virtual properties
	 * @include              A list of keys to include in the population ONLY
	 * @exclude              A list of keys to exclude from the population
	 * @ignoreEmpty          Ignore empty values on populations, great for ORM population
	 * @nullEmptyInclude     A list of keys to NULL when empty
	 * @nullEmptyExclude     A list of keys to NOT NULL when empty
	 * @composeRelationships Automatically attempt to compose relationships from the incoming properties memento
	 * @prefix               The prefix used to filter, Example: 'user' would apply to the following formfield: 'user_id' and 'user_name' but not 'address_id'
	 */
	any function populateWithPrefix(
		required any target,
		required struct memento,
		string scope                 = "",
		boolean trustedSetter        = false,
		string include               = "",
		string exclude               = "",
		boolean ignoreEmpty          = false,
		string nullEmptyInclude      = "",
		string nullEmptyExclude      = "",
		boolean composeRelationships = true,
		required string prefix
	){
		return getObjectPopulator().populateFromStructWithPrefix( argumentCollection = arguments );
	}

	/**
	 * Populate from JSON, for argument definitions look at the populate method
	 *
	 * @target               The entity to populate
	 * @jsonString           The Json string to use for population
	 * @scope                Use scope injection instead of setter injection, no need of setters, just tell us what scope to inject to
	 * @trustedSetter        Do not check if the setter exists, just call it, great for usage with onMissingMethod() and virtual properties
	 * @include              A list of keys to include in the population ONLY
	 * @exclude              A list of keys to exclude from the population
	 * @ignoreEmpty          Ignore empty values on populations, great for ORM population
	 * @nullEmptyInclude     A list of keys to NULL when empty
	 * @nullEmptyExclude     A list of keys to NOT NULL when empty
	 * @composeRelationships Automatically attempt to compose relationships from the incoming properties memento
	 */
	any function populateFromJson(
		required any target,
		required string jsonString,
		string scope                 = "",
		boolean trustedSetter        = false,
		string include               = "",
		string exclude               = "",
		boolean ignoreEmpty          = false,
		string nullEmptyInclude      = "",
		string nullEmptyExclude      = "",
		boolean composeRelationships = true
	){
		return getObjectPopulator().populateFromJSON( argumentCollection = arguments );
	}

	/**
	 * Populate from XML, for argument definitions look at the populate method
	 *
	 * @target               The entity to populate
	 * @xml                  The XML string or packet or XML object to populate from
	 * @root                 The XML root element to start from
	 * @scope                Use scope injection instead of setter injection, no need of setters, just tell us what scope to inject to
	 * @trustedSetter        Do not check if the setter exists, just call it, great for usage with onMissingMethod() and virtual properties
	 * @include              A list of keys to include in the population ONLY
	 * @exclude              A list of keys to exclude from the population
	 * @ignoreEmpty          Ignore empty values on populations, great for ORM population
	 * @nullEmptyInclude     A list of keys to NULL when empty
	 * @nullEmptyExclude     A list of keys to NOT NULL when empty
	 * @composeRelationships Automatically attempt to compose relationships from the incoming properties memento
	 * @prefix               The prefix used to filter, Example: 'user' would apply to the following formfield: 'user_id' and 'user_name' but not 'address_id'
	 */
	any function populateFromXml(
		required any target,
		required string xml,
		string root                  = "",
		string scope                 = "",
		boolean trustedSetter        = false,
		string include               = "",
		string exclude               = "",
		boolean ignoreEmpty          = false,
		string nullEmptyInclude      = "",
		string nullEmptyExclude      = "",
		boolean composeRelationships = true
	){
		return getObjectPopulator().populateFromXML( argumentCollection = arguments );
	}

	/**
	 * Populate from Query, for argument definitions look at the populate method
	 *
	 * @target               The entity to populate
	 * @qry                  The query to use for population
	 * @rowNumber            The row number to use for population
	 * @scope                Use scope injection instead of setter injection, no need of setters, just tell us what scope to inject to
	 * @trustedSetter        Do not check if the setter exists, just call it, great for usage with onMissingMethod() and virtual properties
	 * @include              A list of keys to include in the population ONLY
	 * @exclude              A list of keys to exclude from the population
	 * @ignoreEmpty          Ignore empty values on populations, great for ORM population
	 * @nullEmptyInclude     A list of keys to NULL when empty
	 * @nullEmptyExclude     A list of keys to NOT NULL when empty
	 * @composeRelationships Automatically attempt to compose relationships from the incoming properties memento
	 */
	any function populateFromQuery(
		required any target,
		required any qry,
		numeric rowNumber            = 1,
		string scope                 = "",
		boolean trustedSetter        = false,
		string include               = "",
		string exclude               = "",
		boolean ignoreEmpty          = false,
		string nullEmptyInclude      = "",
		string nullEmptyExclude      = "",
		boolean composeRelationships = true
	){
		return getObjectPopulator().populateFromQuery( argumentCollection = arguments );
	}

	/**
	 * @deprecated Please do not use. Use `getObjectPopulator()`
	 */
	function getBeanPopulator(){
		return getObjectPopulator();
	}

	/**
	 * Get access to the object populator objet
	 *
	 * @return coldbox.system.core.dynamic.ObjectPopulator
	 */
	function getObjectPopulator(){
		if ( !isNull( variables.objectPopulator ) ) {
			return variables.objectPopulator;
		}
		variables.objectPopulator = variables.wirebox.getObjectPopulator();
		return variables.objectPopulator;
	}

	/*****************************************************************************************/
	/********************************* ENTITY UTILITY METHODS ********************************/
	/*****************************************************************************************/

	/**
	 * Merge an entity or array of entities back into a session
	 *
	 * @entity A single or an array of entities to re-merge
	 *
	 * @return Same entity if one passed, array if an array of entities passed.
	 */
	any function merge( required any entity ){
		if ( !isArray( arguments.entity ) ) {
			return entityMerge( arguments.entity );
		}

		var aReturns = [];
		for ( var thisObject in arguments.entity ) {
			arrayAppend( aReturns, entityMerge( thisObject ) );
		}

		return aReturns;
	}

	/**
	 * Refresh the state of an entity or array of entities from the database
	 *
	 * @entity The entity or array of entities to refresh
	 */
	BaseORMService function refresh( required any entity ){
		var aObjects = [];

		if ( !isArray( arguments.entity ) ) {
			aObjects.append( arguments.entity );
		} else {
			aObjects = arguments.entity;
		}

		aObjects.each( function( item ){
			getOrm().getSession( getOrm().getEntityDatasource( item ) ).refresh( item );
		} );

		// Null it due to closure memory bugs on some engines
		aObjects = nullValue();

		return this;
	}

	/**
	 * Get an array of properties that are dirty in the entity, empty array if none.
	 *
	 * @entity The entity to check
	 */
	array function getDirtyPropertyNames( required entity ){
		var thisSession = getOrm().getSession( getOrm().getEntityDatasource( arguments.entity ) );
		var hibernateMD = getEntityMetadata( arguments.entity );
		var dbState     = hibernateMD.getDatabaseSnapshot( getKeyValue( entity ), thisSession );

		// If this is null, then the entity is not in session
		if ( isNull( dbState ) ) {
			return [];
		}

		var currentState = getPropertyValues( thisSession, hibernateMD, arguments.entity );

		var modified = hibernateMD.findModified(
			dbState,
			currentState,
			arguments.entity,
			thisSession
		);
		var dirtyArray = !isNull( local.modified ) ? modified : [];

		return arrayMap( dirtyArray, function( index ){
			return hibernateMD.getSubclassPropertyName( index );
		} );
	}

	/**
	 * Verifies if the entity has dirty data or not.  If the entity is not loaded in session, this method will throw an exception.
	 *
	 * @entity The entity to check if lazy
	 */
	boolean function isDirty( required entity ){
		var thisSession = getOrm().getSession( getOrm().getEntityDatasource( arguments.entity ) );
		var hibernateMD = getEntityMetadata( arguments.entity );
		var dbState     = hibernateMD.getDatabaseSnapshot( getKeyValue( arguments.entity ), thisSession );

		// If this is null, then the entity is not in session
		if ( isNull( dbState ) ) {
			return false;
		}

		var currentState = getPropertyValues( thisSession, hibernateMD, arguments.entity );

		var modified = hibernateMD.findModified(
			dbState,
			currentState,
			arguments.entity,
			thisSession
		);
		var dirtyArray = !isNull( local.modified ) ? modified : [];

		return ( arrayLen( dirtyArray ) > 0 );
	}

	/**
	 * Get the unique identifier value for the passed in entity, or null if the instance is not in session
	 *
	 * @entity The entity to inspect for it's id
	 */
	any function getKeyValue( required entity ){
		try {
			return getORM()
				.getSession( getOrm().getEntityDatasource( arguments.entity ) )
				.getIdentifier( arguments.entity );
		} catch ( any e ) {
			return;
		}
	}

	/**
	 * Returns the key (id field) of a given entity, either simple or composite keys.
	 * If the key is a simple pk then it will return a string, if it is a composite key then it returns an array.
	 * If the key cannot be identified then a blank string is returned.
	 *
	 * @entity The entity name or entity object
	 *
	 * @return string or array
	 */
	any function getKey( required entity ){
		var hibernateMD = getEntityMetadata( arguments.entity );

		// Is this a simple key?
		if ( hibernateMD.hasIdentifierProperty() ) {
			return hibernateMD.getIdentifierPropertyName();
		}

		// Composite Keys?
		if ( hibernateMD.getIdentifierType().isComponentType() ) {
			// Do conversion to CF Array instead of java array, just in case
			return listToArray( arrayToList( hibernateMD.getIdentifierType().getPropertyNames() ) );
		}

		return "";
	}

	/**
	 * Returns the Property Names of the entity via hibernate metadata
	 *
	 * @entity The entity name or the actual entity object
	 */
	array function getPropertyNames( required entity ){
		return getEntityMetadata( arguments.entity ).getPropertyNames();
	}

	/**
	 * Returns the table name that the current entity belongs to via hibernate metadata
	 *
	 * @entity The entity name or the actual entity object
	 */
	string function getTableName( required entity ){
		return getEntityMetadata( arguments.entity ).getTableName();
	}

	/**
	 * Get an entity's hibernate metadata
	 *
	 * @see    https://docs.jboss.org/hibernate/orm/3.5/javadocs/org/hibernate/metadata/ClassMetadata.html
	 * @entity The entity name or entity object
	 *
	 * @return The Hibernate Java ClassMetadata Object
	 */
	function getEntityMetadata( required entity ){
		return getOrm().getEntityMetadata(
			entityName = ( isObject( arguments.entity ) ? getEntityGivenName( arguments.entity ) : arguments.entity ),
			datasource = getOrm().getEntityDatasource( arguments.entity, getDatasource() )
		);
	}

	/**
	 * Returns the entity name from a given entity object via session lookup or if new object via metadata lookup
	 *
	 * @entity The entity to get it's name from
	 */
	function getEntityGivenName( required entity ){
		// Short-cut discovery via ActiveEntity
		if ( structKeyExists( arguments.entity, "getEntityName" ) ) {
			return arguments.entity.getEntityName();
		}

		// Hibernate Discovery
		try {
			var entityName = getOrm()
				.getSession( getOrm().getEntityDatasource( arguments.entity ) )
				.getEntityName( arguments.entity );
		} catch ( org.hibernate.TransientObjectException e ) {
			// ignore it, it is not in session, go for long-discovery
		}

		// Long Discovery
		var md = getMetadata( arguments.entity );
		return ( md.keyExists( "entityName" ) ? md.entityName : listLast( md.name, "." ) );
	}

	/*****************************************************************************************/
	/********************************* DELETION METHODS ************************************/
	/*****************************************************************************************/

	/**
	 * Delete an entity. The entity argument can be a single entity
	 * or an array of entities. You can optionally flush the session also after committing
	 * Transactions are used if useTransactions bit is set or the transactional argument is passed
	 *
	 * @entity        The entity or array of entities to delete
	 * @flush         Do a flush after deleting, false by default since we use transactions
	 * @transactional Wrap it in a `cftransaction`, defaults to true
	 */
	BaseORMService function delete(
		required any entity,
		boolean flush         = false,
		boolean transactional = getUseTransactions()
	){
		return $transactioned(
			function( entity, flush ){
				var objects = [];

				if ( !isArray( arguments.entity ) ) {
					arrayAppend( objects, arguments.entity );
				} else {
					objects = arguments.entity;
				}

				objects.each( function( item ){
					entityDelete( item );
				} );

				objects = nullValue();

				// Flush?
				if ( arguments.flush ) {
					getOrm().flush();
				}

				return this;
			},
			arguments,
			arguments.transactional
		);
	}

	/**
	 * Delete all entries for an entity DLM style and transaction safe. It also returns all the count of deletions
	 * Transactions are used if useTransactions bit is set or the transactional argument is passed
	 *
	 * @entityName    The entity name to delete all from
	 * @flush         Do a flush after deleting, false by default since we use transactions
	 * @transactional Wrap it in a `cftransaction`, defaults to true
	 */
	numeric function deleteAll(
		required string entityName,
		boolean flush         = false,
		boolean transactional = getUseTransactions()
	){
		return $transactioned(
			function( entityName, flush ){
				var options = { "datasource" : getOrm().getEntityDatasource( arguments.entityName ) };

				var count = ormExecuteQuery(
					"delete from #arguments.entityName#",
					false,
					options
				);

				// Auto Flush
				if ( arguments.flush ) {
					getOrm().flush( options.datasource );
				}

				return count;
			},
			arguments,
			arguments.transactional
		);
	}

	/**
	 * Delete using an entity name and an id, you can also flush the session if needed.
	 * Please note that this runs an HQL bulk delete operations so no cascades will take effect.  If you want cascades to occur
	 * then use the `delete()` operation instead.
	 * The id parameter can be a single id or an array of IDs to delete
	 * The method returns the count of deleted entities.
	 * Transactions are used if useTransactions bit is set or the transactional argument is passed
	 *
	 * @entityName    The entity name target
	 * @id            The single id or an array of Ids to delete
	 * @flush         Do a flush after deleting, false by default since we use transactions
	 * @transactional Wrap it in a `cftransaction`, defaults to true
	 */
	numeric function deleteByID(
		required string entityName,
		required any id,
		boolean flush         = false,
		boolean transactional = getUseTransactions()
	){
		return $transactioned(
			function( entityName, id, flush ){
				// Bulk Execute
				var count = ormExecuteQuery(
					"delete FROM #arguments.entityName# where id in (:idlist)",
					{ "idlist" : idCast( entity = arguments.entityName, id = arguments.id ) },
					false,
					{ "datasource" : getOrm().getEntityDatasource( arguments.entityName ) }
				);

				// Auto Flush
				if ( arguments.flush ) {
					getOrm().flush( datasource );
				}

				return count;
			},
			arguments,
			arguments.transactional
		);
	}

	/**
	 * Delete using HQL native queries. Do not add the `delete` keyword, this is added automatically for you.
	 *
	 * So you can do <code>deleteByQuery( "from categories where id = :id" )</code>
	 *
	 * @query         The query to use for deletion
	 * @params        The params to bind the query with
	 * @flush         Do a flush after deleting, false by default since we use transactions
	 * @transactional Wrap it in a `cftransaction`, defaults to true
	 * @datasource    Add the datasource to use or defaults
	 */
	numeric function deleteByQuery(
		required string query,
		any params,
		boolean flush         = false,
		boolean transactional = getUseTransactions(),
		string datasource     = getDatasource()
	){
		return $transactioned(
			function( query, params, flush, datasource ){
				// Bulk Execute
				var count = ormExecuteQuery(
					"delete #arguments.query#",
					arguments.params,
					false,
					{ "datasource" : arguments.datasource }
				);

				// Auto Flush
				if ( arguments.flush ) {
					getOrm().flush( datasource );
				}

				return count;
			},
			arguments,
			arguments.transactional
		);
	}

	/**
	 * Deletes entities by using name value pairs as arguments to this function.
	 * One mandatory argument is to pass the 'entityName'.
	 * The rest of the arguments are used in the where class using <strong>AND</strong> notation and parameterized.
	 *
	 * Ex:
	 * <pre>
	 * deleteWhere(entityName="User",age="4",isActive=true);
	 * </pre>
	 *
	 * @entityName    The entity name to target
	 * @flush         Do a flush after deleting, false by default since we use transactions
	 * @transactional Wrap it in a `cftransaction`, defaults to true
	 * @datasource    The datasource to use or the default one
	 */
	numeric function deleteWhere(
		required string entityName,
		boolean flush         = false,
		boolean transactional = getUseTransactions(),
		datasource            = getDatasource()
	){
		return $transactioned(
			function( entityName, flush, datasource ){
				var sqlBuffer = getStringBuilder( "delete from #arguments.entityName#" );

				// Do we have arguments?
				if ( structCount( arguments ) > 3 ) {
					sqlBuffer.append( " WHERE" );
				} else {
					throw(
						message = "No where arguments sent, aborting deletion",
						detail  = "We will not do a full delete via this method, you need to pass in named value arguments.",
						type    = "BaseORMService.NoWhereArgumentsFound"
					);
				}

				// Go over Params and incorporate them
				var params = arguments
					// filter out reserved names
					.filter( function( key, value ){
						return ( !listFindNoCase( "entityName,flush,datasource", arguments.key ) );
					} )
					.reduce( function( accumulator, key, value ){
						accumulator[ key ] = value;
						sqlBuffer.append( " #key# = :#key# AND" );
						return accumulator;
					}, {} );

				// Finalize ANDs
				sqlBuffer.append( " 1 = 1" );

				// start DLM deleteion
				try {
					var count = ormExecuteQuery(
						sqlBuffer.toString(),
						params,
						false,
						{ datasource : arguments.datasource }
					);
				} catch ( "java.lang.NullPointerException" e ) {
					throw(
						message = "A null pointer exception occurred when running the query",
						detail  = "The most likely reason is that the keys in the passed in structure need to be case sensitive. Passed Keys=#structKeyList( arguments )#",
						type    = "BaseORMService.MaybeInvalidParamCaseException"
					);
				} catch ( any e ) {
					rethrow;
				}

				return count;
			},
			arguments,
			arguments.transactional
		);
	}

	/*****************************************************************************************/
	/********************************* SAVE METHODS ******************************************/
	/*****************************************************************************************/

	/**
	 * Saves an array of passed entities in specified order in a single transaction block
	 *
	 * @entities      An array of entities to save
	 * @forceInsert   Defaults to false, but if true, will insert as new record regardless
	 * @flush         Do a flush after saving the entries, false by default since we use transactions
	 * @transactional Wrap it in a `cftransaction`, defaults to true
	 */
	BaseORMService function saveAll(
		required entities,
		forceInsert           = false,
		boolean flush         = false,
		boolean transactional = getUseTransactions()
	){
		return $transactioned(
			function( entities, forceInsert, flush ){
				var eventHandling = getEventHandling();

				// iterate and save
				for ( var thisEntity in arguments.entities ) {
					// Event Handling? If enabled, call the preSave() interception
					if ( eventHandling ) {
						getORMEventHandler().preSave( thisEntity );
					}

					// Save it
					entitySave( thisEntity, arguments.forceInsert );

					// Event Handling? If enabled, call the postSave() interception
					if ( eventHandling ) {
						getORMEventHandler().postSave( thisEntity );
					}
				}

				// Auto Flush
				if ( arguments.flush ) {
					getOrm().flush( getDatasource() );
				}

				return this;
			},
			arguments,
			arguments.transactional
		);
	}

	/**
	 * Save an entity using hibernate transactions or not. You can optionally flush the session also
	 *
	 * @entity        The entity to save
	 * @forceInsert   Defaults to false, but if true, will insert as new record regardless
	 * @flush         Do a flush after saving the entity, false by default since we use transactions
	 * @transactional Wrap it in a `cftransaction`, defaults to true
	 *
	 * @return saved entity or array of entities
	 */
	any function save(
		required any entity,
		boolean forceInsert   = false,
		boolean flush         = false,
		boolean transactional = getUseTransactions()
	){
		return $transactioned(
			function( entity, forceInsert, flush ){
				// Event handling flag
				var eventHandling = getEventHandling();

				// Event Handling? If enabled, call the preSave() interception
				if ( eventHandling ) {
					getORMEventHandler().preSave( arguments.entity );
				}

				// save
				entitySave( arguments.entity, arguments.forceInsert );

				// Auto Flush
				if ( arguments.flush ) {
					getOrm().flush( getOrm().getEntityDatasource( arguments.entity ) );
				}

				// Event Handling? If enabled, call the postSave() interception
				if ( eventHandling ) {
					getORMEventHandler().postSave( arguments.entity );
				}

				return arguments.entity;
			},
			arguments,
			arguments.transactional
		);
	}

	/*****************************************************************************************/
	/********************************* COUNTER METHODS ***************************************/
	/*****************************************************************************************/

	/**
	 * Checks if the given entityName and id exists in the database, this method does not load the entity into session
	 *
	 * @entityName The name of the entity
	 * @id         The id to lookup
	 */
	boolean function exists( required entityName, required any id ){
		// Do it DLM style
		var count = ormExecuteQuery(
			"select count( id ) from #arguments.entityName# where id = :id",
			{ id : arguments.id },
			true,
			{ datasource : getOrm().getEntityDatasource( arguments.entityName ) }
		);

		return ( count gt 0 );
	}

	/**
	 * Return the count of records in the DB for the given entity name. You can also pass an optional where statement
	 * that can filter the count. Ex: <code>count( 'User','age > 40 AND name="joe"' )</code>. You can even use params with this method:
	 * Ex: <code>count('User','age > ? AND name = ?',[40,"joe"])</code>
	 *
	 * @entityName The name of the entity
	 * @where      The HQL where statement
	 * @params     Any params to bind in the where argument
	 */
	numeric function count(
		required string entityName,
		string where = "",
		any params   = structNew()
	){
		var buffer  = getStringBuilder();
		var options = { "datasource" : getOrm().getEntityDatasource( arguments.entityName ) };


		// Caching?
		if ( getUseQueryCaching() ) {
			options.cacheName = getQueryCacheRegion();
			options.cacheable = true;
		}

		// HQL
		buffer.append( "select count( id ) from #arguments.entityName#" );

		// build params
		if ( len( trim( arguments.where ) ) ) {
			buffer.append( " WHERE #trim( arguments.where )#" );
		}

		// execute query as unique for the count
		try {
			return ormExecuteQuery(
				buffer.toString(),
				arguments.params,
				true,
				options
			);
		} catch ( "java.lang.NullPointerException" e ) {
			throw(
				message = "A null pointer exception occurred when running the query",
				detail  = "The most likely reason is that the keys in the passed in structure need to be case sensitive. Passed Keys	=#structKeyList( arguments.params )#",
				type    = "ORMService.MaybeInvalidParamCaseException"
			);
		}
	}

	/**
	 * Returns the count by passing name value pairs as arguments to this function.  One mandatory argument is to pass the 'entityName'.
	 * The rest of the arguments are used in the where class using AND notation and parameterized.
	 * Ex: <code>countWhere( entityName="User", age="20" );</code>
	 *
	 * @entityName The entity name to count on
	 */
	numeric function countWhere( required string entityName ){
		var sqlBuffer = getStringBuilder( "select count(id) from #arguments.entityName#" );
		var options   = { datasource : getOrm().getEntityDatasource( arguments.entityName ) };

		// Do we have arguments?
		var params = {};
		if ( structCount( arguments ) > 1 ) {
			sqlBuffer.append( " WHERE" );

			// Go over Params and incorporate them
			params = arguments
				// filter out reserved names
				.filter( function( key, value ){
					return ( !listFindNoCase( "entityName", arguments.key ) );
				} )
				.reduce( function( accumulator, key, value ){
					accumulator[ key ] = value;
					sqlBuffer.append( " #key# = :#key# AND" );
					return accumulator;
				}, {} );

			// Finalize ANDs
			sqlBuffer.append( " 1 = 1" );
		}

		// Caching?
		if ( getUseQueryCaching() ) {
			options.cacheName = getQueryCacheRegion();
			options.cacheable = true;
		}

		// execute query as unique for the count
		try {
			return ormExecuteQuery( sqlBuffer.toString(), params, true, options );
		} catch ( "java.lang.NullPointerException" e ) {
			throw(
				message = "A null pointer exception occurred when running the query",
				detail  = "The most likely reason is that the keys in the passed in structure need to be case sensitive. Passed Keys=#structKeyList( arguments )#",
				type    = "BaseORMService.MaybeInvalidParamCaseException"
			);
		} catch ( any e ) {
			rethrow;
		}
	}

	/*****************************************************************************************/
	/********************************* EVICTION METHODS **************************************/
	/*****************************************************************************************/

	/**
	 * Evict all the collection or association data for a given entity name and collection name from the secondary cache ONLY, not the hibernate session
	 * Evict an entity name with or without an ID from the secondary cache ONLY, not the hibernate session
	 *
	 * @entityName   The entity name to evict or use in the eviction process
	 * @relationName The name of the relation in the entity to evict
	 * @id           The id to use for eviction according to entity name or relation name
	 */
	any function evictCollection(
		required string entityName,
		string relationName,
		any id
	){
		// With Relation
		if ( !isNull( arguments.relationName ) ) {
			if ( !isNull( arguments.id ) )
				ormEvictCollection(
					arguments.entityName,
					arguments.relationName,
					arguments.id
				);
			else ormEvictCollection( arguments.entityName, arguments.relationName );

			return this;
		}

		// Single Entity
		if ( !isNull( arguments.id ) ) ormEvictEntity( arguments.entityName, arguments.id );
		else ormEvictEntity( arguments.entityName );

		return this;
	}

	/**
	 * Evict entity object(s) from the hibernate session or first-level cache
	 *
	 * 1) An entity object
	 * 2) An array of entity objects
	 *
	 * @entities The argument can be one persistence entity or an array of entities to evict
	 */
	BaseORMService function evict( required any entities ){
		if ( !isArray( arguments.entities ) ) {
			arguments.entities = [ arguments.entities ];
		}

		arguments.entities.each( function( item ){
			getOrm().getSession( getOrm().getEntityDatasource( item ) ).evict( item );
		} );

		return this;
	}

	/**
	 * Evict all queries in the default cache or the cache region passed
	 *
	 * @cacheName  The cache region to evict from or if empty from the default cache region
	 * @datasource The specific datasource to use or the default datasource
	 */
	BaseORMService function evictQueries( string cacheName, string datasource = getDatasource() ){
		getOrm().evictQueries( argumentCollection = arguments );
		return this;
	}

	/*****************************************************************************************/
	/********************************* ORM UTILITIES *****************************************/
	/*****************************************************************************************/

	/**
	 * Build a java proxy object using our Java Proxy Builder
	 *
	 * @type The type of Java Proxy class to build using our Java Proxy Builder
	 */
	function buildJavaProxy( required type ){
		if ( isNull( variables.javaProxyBuilder ) ) {
			variables.javaProxyBuilder = getWireBox().getInstance( "JavaProxyBuilder@cborm" );
		}
		return variables.javaProxyBuilder.build( arguments.type );
	}

	/**
	 * Clear the session removes all the entities that are loaded or created in the session.
	 * This clears the first level cache and removes the objects that are not yet saved to the database.
	 *
	 * @datasource The datasource to use
	 */
	BaseORMService function clear( string datasource = getDatasource() ){
		getOrm().clearSession( arguments.datasource );
		return this;
	}

	/**
	 * Checks if the hibernate session contains dirty objects that are awaiting persistence
	 */
	boolean function isSessionDirty( string datasource = getDatasource() ){
		return getOrm().getSession( arguments.datasource ).isDirty();
	}

	/**
	 * Checks if the current hibernate session contains the passed in entity.
	 *
	 * @entity The entity object
	 */
	boolean function sessionContains( required any entity ){
		var ormSession = getOrm().getSession( getOrm().getEntityDatasource( arguments.entity ) );
		// Hibernate 5 Approach: left( getOrm().getHibernateVersion(), 1 ) > 5
		if ( server.coldfusion.productVersion.listFirst() >= 2018 ) {
			return ormSession.contains( getEntityGivenName( arguments.entity ), arguments.entity );
		}
		return ormSession.contains( arguments.entity );
	}

	/**
	 * Information about the first-level (session) cache for the current session
	 *
	 * @datasource The datasource to use
	 */
	struct function getSessionStatistics( string datasource = getDatasource() ){
		var stats = getOrm().getSession( arguments.datasource ).getStatistics();

		return {
			"collectionCount" : stats.getCollectionCount(),
			"collectionKeys"  : stats.getCollectionKeys().toString(),
			"entityCount"     : stats.getEntityCount(),
			"entityKeys"      : stats.getEntityKeys().toString()
		};
	}

	/**
	 * This method listens to non-existent method to create fluently:
	 *
	 * 1) FindByXXX operations
	 * 2) FindAllByXXX operations
	 * 3) countByXXX operations
	 *
	 * You can pass in the arguments a structure of options by calling it `options` or the last
	 * argument which is a struct will be used.  Options can contain the following keys:
	 *
	 * - ignoreCase:boolean (false)
	 * - maxResults:numeric (0)
	 * - offset:numeric (0)
	 * - cacheable:boolean (false)
	 * - cacheName:string ("default")
	 * - timeout:numeric (0=no timeout)
	 * - datasource:string (default datasource)
	 * - sortBy:hql (empty)
	 * - autoCast:boolean (true)
	 *
	 * Else it throws a method does not exist exception
	 *
	 * @throws MissingMethodException
	 */
	any function onMissingMethod( string missingMethodName, struct missingMethodArguments ){
		var method = arguments.missingMethodName;
		var args   = arguments.missingMethodArguments;

		// Dynamic Find Unique Finders
		if ( left( method, 6 ) eq "findBy" and len( method ) GT 6 ) {
			return getDynamicProcessor().
process(
				method     = right( method, len( method ) - 6 ),
				args       = args,
				unique     = true,
				ormService = this
			);
		}
		// Dynamic find All Finders
		if ( left( method, 9 ) eq "findAllBy" and len( method ) GT 9 ) {
			return getDynamicProcessor().
process(
				method     = right( method, len( method ) - 9 ),
				args       = args,
				unique     = false,
				ormService = this
			);
		}
		// Dynamic countBy Finders
		if ( left( method, 7 ) eq "countBy" and len( method ) GT 7 ) {
			return getDynamicProcessor().
process(
				method     = right( method, len( method ) - 7 ),
				args       = args,
				unique     = true,
				isCounting = true,
				ormService = this
			);
		}

		// Throw exception, method not found.
		throw(
			message = "Invalid method call: #arguments.missingMethodName#",
			detail  = "The method you called does not exist in this component",
			type    = "MissingMethodException"
		);
	}

	/*****************************************************************************************/
	/********************************* CRITERIA METHODS **************************************/
	/*****************************************************************************************/

	/**
	 * Get our hibernate org.hibernate.criterion.Restrictions proxy object
	 *
	 * @return cborm.models.criterion.Restrictions
	 */
	function getRestrictions(){
		// Lazy Loading injection
		if ( !isNull( variables.restrictions ) ) {
			return variables.restrictions;
		}
		variables.restrictions = variables.wirebox.getInstance( "Restrictions@cborm" );
		return variables.restrictions;
	}

	/**
	 * Get a brand new criteria builder object
	 *
	 * @entityName       The name of the entity to bind this criteria query to
	 * @useQueryCaching  Activate query caching for the list operations
	 * @queryCacheRegion The query cache region to use, which defaults to criterias.{entityName}
	 * @defaultAsQuery   To return results as queries or array of objects or reports, default is array as results might not match entities precisely
	 * @dataSource       The datasource to bind the criteria query on, defaults to the one in this ORM service
	 *
	 * @return cborm.models.criterion.CriteriaBuilder
	 */
	any function newCriteria(
		required string entityName,
		boolean useQueryCaching = false,
		string queryCacheRegion = "",
		datasource              = getDatasource()
	){
		// mix in yourself as a dependency
		arguments.ormService = this;
		// create new criteria builder, it's a transient
		return variables.wirebox.getInstance( "CriteriaBuilder@cborm", arguments );
	}


	/*****************************************************************************************/
	/********************************* PRIVATE METHODS **************************************/
	/*****************************************************************************************/

	/**
	 * Get property values for the given entity.
	 *
	 * @ormSession        the current ORM session. Will (probably) throw an exception if session is not open.
	 * @hibernateMetadata a `ClassMetadata` Hibernate object populated with entity meta. See `getEntityMetadata`
	 * @entity            The entity to retrieve property values on.
	 * @see               https://docs.jboss.org/hibernate/orm/5.4/javadocs/org/hibernate/persister/entity/EntityPersister.html#getPropertyValues-java.lang.Object-
	 */
	private function getPropertyValues(
		required ormSession,
		required hibernateMetadata,
		required entity
	){
		if ( val( left( getOrm().getHibernateVersion(), 3 ) ) < 4.0 ) {
			return arguments.hibernateMetadata.getPropertyValues(
				arguments.entity,
				getOrm().getSessionEntityMode( arguments.ormSession, arguments.entity )
			);
		} else {
			return arguments.hibernateMetadata.getPropertyValues( arguments.entity );
		}
	}

	/**
	 * My hibernate safe transaction closure wrapper, Transactions are per request basis
	 *
	 * @target        The closure or UDF to execute
	 * @argCollection The arguments
	 * @transactional Whether to apply the transactions or not.
	 */
	private any function $transactioned(
		required target,
		argCollection         = {},
		boolean transactional = getUseTransactions()
	){
		// Clean up the arg collection
		structDelete( arguments.argCollection, "transactional" );

		// If in transaction, just execute the incoming target
		if ( request.keyExists( "cbox_aop_transaction" ) OR !arguments.transactional ) {
			return arguments.target( argumentCollection = arguments.argCollection );
		}
		// transaction safe call, start one, so we can support nested transactions
		// mark transaction began
		request[ "cbox_aop_transaction" ] = true;

		transaction {
			try {
				// Call method
				var results = arguments.target( argumentCollection = arguments.argCollection );
			} catch ( Any e ) {
				// RollBack Transaction
				transactionRollback();
				// throw it back folks
				rethrow;
			} finally {
				// remove pointer
				request.delete( "cbox_aop_transaction" );
			}
		}
		// end transaction

		if ( !isNull( results ) ) {
			return results;
		}
	}

	/**
	 * Build out a Java string builder
	 *
	 * @seed The string to seed the builder with
	 *
	 * @return java.lang.StringBuilder
	 */
	private function getStringBuilder( seed = "" ){
		return createObject( "java", "java.lang.StringBuilder" ).init( arguments.seed );
	}

}

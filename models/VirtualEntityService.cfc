/**
 * ********************************************************************************
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ********************************************************************************
 *
 * This is a Virtual Entity Service that extends the Coldbox BaseORMService to
 * provide easy access to creating virtual services that extend the BaseORMService
 *
 * For example, if you want a UserService, you can either create an object based
 * off this object if no additional functionality is needed like this:
 *
 * <pre>
 * UserService=CreateObject("component", "cborm.models.VirtualEntityService").init("User");
 * </pre>
 *
 * You can also use this virtual service as a template object and extend and override as needed.
 *
 * <pre>
 * import cborm.models.*;
 * component extends="VirtualEntityService"
 * UserService function init(){
 * // setup properties
 * setEntityName('User');
 * setQueryCacheRegion( "#arguments.entityName#.defaultVSCache" );
 * setUseQueryCaching( false );
 * setEventHandling( false );
 * setDefaultAsQuery( true );
 * return this;
 * }
 * </pre>
 *
 * @author Curt Gratz & Luis Majano
 */
component extends="cborm.models.BaseORMService" accessors="true" {

	/**
	 * The entity name that this virtual service is bound to. All operations will be based off this entity name
	 */
	property
		name      ="entityName"
		type      ="string"
		persistent="false";

	/************************************** CONSTRUCTOR *********************************************/

	/**
	 * Constructor
	 *
	 * @entityname       The name of the entity to root this service with
	 * @queryCacheRegion The name of the query cache region if using caching, defaults to `#arguments.entityName#.defaultVSCache`
	 * @useQueryCaching  Activate query caching, defaults to false
	 * @eventHandling    Activate event handling, defaults to true
	 * @useTransactions  Activate transaction blocks on calls, defaults to true
	 * @defaultAsQuery   Return query or array of objects on list(), executeQuery() defaults to false
	 * @datasource       THe datsource name to be used for the rooted entity, if not we use the default datasource
	 */
	VirtualEntityService function init(
		required string entityname,
		string queryCacheRegion,
		boolean useQueryCaching,
		boolean eventHandling,
		boolean useTransactions,
		boolean defaultAsQuery,
		string datasource
	){
		// Default a cache region if not passed
		if ( isNull( arguments.queryCacheRegion ) ) {
			arguments.queryCacheRegion = "#arguments.entityName#.defaultVSCache";
		}

		// Set the local entity to be used in this virtual entity service
		variables.entityName = arguments.entityName;

		// Init our parent
		super.init( argumentCollection = arguments );

		// Datasource determination
		if ( isNull( arguments.datasource ) && !structKeyExists( this, "activeEntity" ) ) {
			variables.datasource = getOrm().getEntityDatasource( arguments.entityName, variables.datasource );
		}

		return this;
	}

	/************************************** PUBLIC *********************************************/

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
	 */
	any function executeQuery(
		required string query,
		any params         = structNew(),
		numeric offset     = 0,
		numeric max        = 0,
		numeric timeout    = 0,
		boolean ignorecase = false,
		boolean asQuery    = getDefaultAsQuery(),
		boolean unique     = false
	){
		arguments.datasource = this.getDatasource();
		return super.executeQuery( argumentCollection = arguments );
	}

	/**
	 * List all of the instances of the passed in entity class name. You can pass in several optional arguments like
	 * a struct of filtering criteria, a sortOrder string, offset, max, ignorecase, and timeout.
	 *
	 * Caching for the list is based on the useQueryCaching class property and the cachename property is based on
	 * the queryCacheRegion class property.
	 *
	 * @criteria   A struct of filtering criteria to apply to the where clause
	 * @sortOrder  The sorting order of the result
	 * @offset     Used for pagination
	 * @max        The max number of records to retrieve
	 * @timeout    A DB timeout for this query
	 * @ignoreCase Case insensitive or case sensitive searches, we default to case sensitive filtering.
	 * @asQuery    The return format as either a query or array of objects
	 */
	any function list(
		struct criteria    = structNew(),
		string sortOrder   = "",
		numeric offset     = 0,
		numeric max        = 0,
		numeric timeout    = 0,
		boolean ignoreCase = false,
		boolean asQuery    = getDefaultAsQuery()
	){
		arguments.entityName = this.getEntityName();
		return super.list( argumentCollection = arguments );
	}

	/**
	 * Find one entity (or null if not found) according to a criteria structure
	 *
	 * @criteria The filtering criteria to search for.
	 */
	any function findWhere( required struct criteria ){
		return super.findWhere( this.getEntityName(), arguments.criteria );
	}

	/**
	 * Find all entities according to criteria structure
	 *
	 * @criteria  The filtering criteria to search for.
	 * @sortOrder The sorting order
	 */
	array function findAllWhere( required struct criteria, string sortOrder = "" ){
		return super.findAllWhere(
			this.getEntityName(),
			arguments.criteria,
			arguments.sortOrder
		);
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
		struct properties            = structNew(),
		boolean composeRelationships = true,
		nullEmptyInclude             = "",
		nullEmptyExclude             = "",
		boolean ignoreEmpty          = false,
		include                      = "",
		exclude                      = ""
	){
		arguments.entityName = this.getEntityName();
		return super.new( argumentCollection = arguments );
	}

	/**
	 * Checks if the given entityName and id exists in the database, this method does not load the entity into session
	 *
	 * @id The id to lookup
	 */
	boolean function exists( required any id ){
		arguments.entityName = this.getEntityName();
		return super.exists( argumentCollection = arguments );
	}

	/**
	 * Get an entity using a primary key, if the id is not found this method returns null, if the id=0 or blank it returns a new entity.
	 *
	 * @id        An optional primary key to use to retrieve the entity, if the id is `0` or `empty` it will return a new unloaded entity
	 * @returnNew By default if the primary key is 0 or empty it returns a new unloaded entity, if false, then always null
	 *
	 * @return Requested entity, new entity or `null`
	 */
	any function get( required any id, boolean returnNew = true ){
		arguments.entityName = this.getEntityName();
		return super.get( argumentCollection = arguments );
	}

	/**
	 * Get an entity using a primary key, if the id is not found this method throws an EntityNotFound Exception
	 *
	 * @throws EntityNotFound
	 */
	any function getOrFail( required any id ){
		arguments.entityName = this.getEntityName();
		return super.getOrFail( argumentCollection = arguments );
	}

	/**
	 * Retrieve all the instances from the passed in entity name using the id argument if specified.flash.inflateFlash()
	 * You can also use the properties argument so this method can return to you array of structs instead of array of objects.
	 * The property list must include the `as` alias if not you will get positional keys.
	 * Example: properties="catID as id, category as category, role as role"
	 *
	 * @id         The id or a list/array of Ids to retrieve
	 * @sortOrder  The sorting of the returning array, defaults to natural sorting
	 * @readOnly   Return full or read only entities, defaults to false
	 * @properties If passed, you can retrieve an array of properties of the entity instead of the entire entity.  Make sure you add aliases to the properties: Ex: 'catId as id'
	 */
	array function getAll(
		any id,
		string sortOrder = "",
		boolean readOnly = false,
		string properties
	){
		arguments.entityName = this.getEntityName();
		return super.getAll( argumentCollection = arguments );
	}

	/**
	 * Delete all entries for an entity DLM style and transaction safe. It also returns all the count of deletions
	 * Transactions are used if useTransactions bit is set or the transactional argument is passed
	 *
	 * @flush         Do a flush after deleting, false by default since we use transactions
	 * @transactional Wrap it in a `cftransaction`, defaults to true
	 */
	numeric function deleteAll( boolean flush = false, boolean transactional = getUseTransactions() ){
		arguments.entityName = this.getEntityName();
		return super.deleteAll( arguments.entityName, arguments.flush );
	}

	/**
	 * Delete using an entity name and an incoming id, you can also flush the session if needed. The id parameter can be a single id or an array of IDs to delete
	 * The method returns the count of deleted entities.
	 * Transactions are used if useTransactions bit is set or the transactional argument is passed
	 *
	 * @id            The single id or an array of Ids to delete
	 * @flush         Do a flush after deleting, false by default since we use transactions
	 * @transactional Wrap it in a `cftransaction`, defaults to true
	 */
	numeric function deleteByID(
		required any id,
		boolean flush         = false,
		boolean transactional = getUseTransactions()
	){
		arguments.entityName = this.getEntityName();
		return super.deleteByID( argumentCollection = arguments );
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
	 */
	numeric function deleteByQuery(
		required string query,
		any params,
		boolean flush         = false,
		boolean transactional = getUseTransactions()
	){
		arguments.datasource = this.getDatasource();
		return super.deleteByQuery( argumentCollection = arguments );
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
	 * @flush         Do a flush after deleting, false by default since we use transactions
	 * @transactional Wrap it in a `cftransaction`, defaults to true
	 * @datasource    The datasource to use or the default one
	 */
	numeric function deleteWhere(
		boolean flush         = false,
		boolean transactional = getUseTransactions(),
		datasource            = getDatasource()
	){
		arguments.entityName = this.getEntityName();
		return super.deleteWhere( argumentCollection = arguments );
	}

	/**
	 * Return the count of records in the DB for the given entity name. You can also pass an optional where statement
	 * that can filter the count. Ex: <code>count( 'User','age > 40 AND name="joe"' )</code>. You can even use params with this method:
	 * Ex: <code>count('User','age > ? AND name = ?',[40,"joe"])</code>
	 *
	 * @where  The HQL where statement
	 * @params Any params to bind in the where argument
	 */
	numeric function count( string where = "", any params = structNew() ){
		arguments.entityName = this.getEntityName();
		return super.count( argumentCollection = arguments );
	}

	/**
	 * Returns the count by passing name value pairs as arguments to this function.  One mandatory argument is to pass the 'entityName'.
	 * The rest of the arguments are used in the where class using AND notation and parameterized.
	 * Ex: <code>countWhere( entityName="User", age="20" );</code>
	 */
	numeric function countWhere(){
		arguments.entityName = this.getEntityName();
		return super.countWhere( argumentCollection = arguments );
	}

	/**
	 * Evict all the collection or association data for a given entity name and collection name from the secondary cache ONLY, not the hibernate session
	 * Evict an entity name with or without an ID from the secondary cache ONLY, not the hibernate session
	 *
	 * @relationName The name of the relation in the entity to evict
	 * @id           The id to use for eviction according to entity name or relation name
	 */
	any function evictCollection( string relationName, any id ){
		arguments.entityName = this.getEntityName();
		super.evictCollection( argumentCollection = arguments );
	}

	/**
	 * Returns the key (id field) of a given entity, either simple or composite keys.
	 * If the key is a simple pk then it will return a string, if it is a composite key then it returns an array.
	 * If the key cannot be identified then a blank string is returned.
	 *
	 * @return string or array
	 */
	any function getKey(){
		return super.getKey( this.getEntityName() );
	}

	/**
	 * Returns the Property Names of the entity via hibernate metadata
	 */
	array function getPropertyNames(){
		return super.getPropertyNames( this.getEntityName() );
	}

	/**
	 * Returns the table name that the current entity belongs to via hibernate metadata
	 */
	string function getTableName(){
		return super.getTableName( this.getEntityName() );
	}


	/**
	 * Get a brand new criteria builder object
	 *
	 * @useQueryCaching  Activate query caching for the list operations
	 * @queryCacheRegion The query cache region to use, which defaults to criterias.{entityName}
	 * @defaultAsQuery   To return results as queries or array of objects or reports, default is array as results might not match entities precisely
	 *
	 * @return cborm.models.criterion.CriteriaBuilder
	 */
	any function newCriteria(
		boolean useQueryCaching = false,
		string queryCacheRegion = "",
		datasource              = getDatasource()
	){
		arguments.entityName = this.getEntityName();
		return super.newCriteria( argumentCollection = arguments );
	}

	/**
	 * Coverts an ID, list of ID's, or array of ID's values to the proper Java type
	 * The method returns a coverted array of ID's
	 *
	 * @deprecated In favor of `idCast()`
	 * @id         The id value to convert
	 */
	any function convertIdValueToJavaType( required id ){
		arguments.entity = this.getEntityName();
		return super.idCast( argumentCollection = arguments );
	}

	/**
	 * Convert an Id value to it's Java cast type, this is an alias for `ConvertIdValueToJavaType()`
	 *
	 * @id The id value to convert
	 */
	any function idCast( required id ){
		arguments.entity = this.getEntityName();
		return super.idCast( argumentCollection = arguments );
	}

	/**
	 * Coverts an ID, list of ID's, or array of ID's values to the proper Java type
	 * The method returns a coverted array of ID's
	 *
	 * @deprecated In favor of `idCast()`
	 * @id         The id value to convert
	 */
	any function convertValueToJavaType( required propertyName, required value ){
		arguments.entity = this.getEntityName();
		return super.autoCast( argumentCollection = arguments );
	}

	/**
	 * Coverts a value to the correct javaType for the property passed in.
	 *
	 * @propertyName The property name
	 * @value        The property value
	 */
	any function autoCast( required propertyName, required value ){
		arguments.entity = this.getEntityName();
		return super.autoCast( argumentCollection = arguments );
	}

	/**
	 * A nice onMissingMethod template to create awesome dynamic methods based on a virtual service
	 */
	any function onMissingMethod( string missingMethodName, struct missingMethodArguments ){
		// Add the entity name
		arguments.missingMethodArguments.entityName = this.getEntityName();
		return super.onMissingMethod( argumentCollection = arguments );
	}

}

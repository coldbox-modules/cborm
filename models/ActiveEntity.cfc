/**
 * ********************************************************************************
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ********************************************************************************
 * This Active Entity object allows you to enhance your ORM entities with virtual service methods
 * and make it follow more of an Active Record pattern, but not really :)
 *
 * It just allows you to operate on entity and related entity objects much much more easily.
 *
 * If you have enabled WireBox entity injection, then you will get an added validation features:
 * Just make sure you have the ColdBox Validation module installed ( box install validation )
 *
 * <pre>
 * boolean function isValid(fields="*",constraints="",locale=""){}
 * cbvalidation.model.result.IValidationResult function getValidationResults(){}
 * </pre>
 *
 * These methods are only active if WireBox entity injection is available.
 */
component extends="cborm.models.VirtualEntityService" accessors="true" {

	/**
	 * If populated, it will be from the last cbValidation made on the entity
	 */
	property name="validationResult" persistent="false";

	/**
	 * Marker used for quick determination if we are in an Active Entity or not
	 */
	this.activeEntity = true;

	/**
	 * Active Entity Constructor, if you override it, make sure you call super.init()
	 *
	 * @queryCacheRegion The query cache region to use if not we will use one for you
	 * @useQueryCaching  Enable query caching for this entity or not, defaults to false
	 * @eventHandling    Enable event handling for new() and save() operations, defaults to true
	 * @useTransactions  Enable transactions for all major operations, defaults to true
	 * @defaultAsQuery   Return query or array of objects on list(), executeQuery() defaults to false
	 */
	function init(
		string queryCacheRegion,
		boolean useQueryCaching,
		boolean eventHandling,
		boolean useTransactions,
		boolean defaultAsQuery
	){
		// Calculate name via metadata
		var md               = getMetadata( this );
		arguments.entityName = ( md.keyExists( "entityName" ) ? md.entityName : listLast( md.name, "." ) );

		// Store query cache region
		if ( isNull( arguments.queryCacheRegion ) ) {
			arguments.queryCacheRegion = "#arguments.entityName#.activeEntityCache";
		}

		// Verify datasource just in case.
		if ( md.keyExists( "datasource" ) ) {
			arguments.datasource = md.datasource;
		}

		// init the super class with our own arguments
		super.init( argumentCollection = arguments );

		return this;
	}

	/**
	 * Save an entity using hibernate transactions or not. You can optionally flush the session also
	 *
	 * @entity        The entity to save
	 * @forceInsert   Defaults to false, but if true, will insert as new record regardless
	 * @flush         Do a flush after saving the entity, false by default since we use transactions
	 * @transactional Wrap it in a `cftransaction`, defaults to true
	 *
	 * @return the entity or array of entities saved
	 */
	any function save(
		any entity            = this,
		boolean forceInsert   = false,
		boolean flush         = false,
		boolean transactional = getUseTransactions()
	){
		return super.save( argumentCollection = arguments );
	}

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
		any entity            = this,
		boolean flush         = false,
		boolean transactional = getUseTransactions()
	){
		return super.delete( argumentCollection = arguments );
	}

	/**
	 * Refresh the state of an entity or array of entities from the database
	 *
	 * @entity The entity or array of entities to refresh
	 */
	any function refresh( any entity = this ){
		return super.refresh( arguments.entity );
	}

	/**
	 * Verifies if the entity has dirty data or not.  If the entity is not loaded in session, this method will throw an exception.
	 *
	 * @entity The entity to check if dirty
	 */
	boolean function isDirty( any entity = this ){
		return super.isDirty( arguments.entity );
	}

	/**
	 * Merge an entity or array of entities back into a session
	 *
	 * @entity A single or an array of entities to re-merge
	 *
	 * @return Same entity if one passed, array if an array of entities passed.
	 */
	any function merge( any entity = this ){
		return super.merge( arguments.entity );
	}

	/**
	 * Evict entity object(s) from the hibernate session or first-level cache
	 *
	 * 1) An entity object
	 * 2) An array of entity objects
	 *
	 * @entity The argument can be one persistence entity or an array of entities to evict
	 */
	any function evict( any entity = this ){
		return super.evict( arguments.entity );
	}

	/**
	 * Populate/bind an entity's properties and relationships from an incoming structure or map of flat data.
	 *
	 * @memento              The map/struct to populate the entity with
	 * @scope                Use scope injection instead of setter injection, no need of setters, just tell us what scope to inject to
	 * @trustedSetter        Do not check if the setter exists, just call it, great for usage with onMissingMethod() and virtual properties
	 * @include              A list of keys to include in the population ONLY
	 * @exclude              A list of keys to exclude from the population
	 * @ignoreEmpty          Ignore empty values on populations, great for ORM population
	 * @nullEmptyInclude     A list of keys to NULL when empty
	 * @nullEmptyExclude     A list of keys to NOT NULL when empty
	 * @composeRelationships Automatically attempt to compose relationships from the incoming properties memento
	 * @target               The entity to populate, yourself
	 */
	any function populate(
		required struct memento,
		string scope                 = "",
		boolean trustedSetter        = false,
		string include               = "",
		string exclude               = "",
		boolean ignoreEmpty          = false,
		string nullEmptyInclude      = "",
		string nullEmptyExclude      = "",
		boolean composeRelationships = true,
		any target                   = this
	){
		return getObjectPopulator().populateFromStruct( argumentCollection = arguments );
	}

	/**
	 * Simple map to property population for entities with structure key prefixes
	 *
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
	 * @target               The entity to populate
	 */
	any function populateWithPrefix(
		required struct memento,
		string scope                 = "",
		boolean trustedSetter        = false,
		string include               = "",
		string exclude               = "",
		boolean ignoreEmpty          = false,
		string nullEmptyInclude      = "",
		string nullEmptyExclude      = "",
		boolean composeRelationships = true,
		required string prefix,
		any target = this
	){
		return getObjectPopulator().populateFromStructWithPrefix( argumentCollection = arguments );
	}

	/**
	 * Populate from JSON, for argument definitions look at the populate method
	 *
	 * @jsonString           The Json string to use for population
	 * @scope                Use scope injection instead of setter injection, no need of setters, just tell us what scope to inject to
	 * @trustedSetter        Do not check if the setter exists, just call it, great for usage with onMissingMethod() and virtual properties
	 * @include              A list of keys to include in the population ONLY
	 * @exclude              A list of keys to exclude from the population
	 * @ignoreEmpty          Ignore empty values on populations, great for ORM population
	 * @nullEmptyInclude     A list of keys to NULL when empty
	 * @nullEmptyExclude     A list of keys to NOT NULL when empty
	 * @composeRelationships Automatically attempt to compose relationships from the incoming properties memento
	 * @target               The entity to populate
	 */
	any function populateFromJSON(
		required string JSONString,
		string scope                 = "",
		boolean trustedSetter        = false,
		string include               = "",
		string exclude               = "",
		boolean ignoreEmpty          = false,
		string nullEmptyInclude      = "",
		string nullEmptyExclude      = "",
		boolean composeRelationships = true,
		any target                   = this
	){
		return getObjectPopulator().populateFromJSON( argumentCollection = arguments );
	}

	/**
	 * Populate from XML, for argument definitions look at the populate method
	 *
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
	 * @target               The entity to populate
	 */
	any function populateFromXML(
		required string xml,
		string root                  = "",
		string scope                 = "",
		boolean trustedSetter        = false,
		string include               = "",
		string exclude               = "",
		boolean ignoreEmpty          = false,
		string nullEmptyInclude      = "",
		string nullEmptyExclude      = "",
		boolean composeRelationships = true,
		any target                   = this
	){
		return getObjectPopulator().populateFromXML( argumentCollection = arguments );
	}

	/**
	 * Populate from Query, for argument definitions look at the populate method
	 *
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
	 * @target               The entity to populate
	 */
	any function populateFromQuery(
		required any qry,
		numeric rowNumber            = 1,
		string scope                 = "",
		boolean trustedSetter        = false,
		string include               = "",
		string exclude               = "",
		boolean ignoreEmpty          = false,
		string nullEmptyInclude      = "",
		string nullEmptyExclude      = "",
		boolean composeRelationships = true,
		any target                   = this
	){
		return getObjectPopulator().populateFromQuery( argumentCollection = arguments );
	}

	/**
	 * Validate the ActiveEntity with the coded constraints -> this.constraints, or passed in shared or implicit constraints
	 * The entity must have been populated with data before the validation
	 *
	 * @fields        One or more fields to validate on, by default it validates all fields in the constraints. This can be a simple list or an array.
	 * @constraints   An optional shared constraints name or an actual structure of constraints to validate on.
	 * @locale        An optional locale to use for i18n messages
	 * @excludeFields An optional list of fields to exclude from the validation.
	 * @IncludeFields An optional list of fields to include in the validation.
	 */
	boolean function isValid(
		string fields        = "*",
		any constraints      = "",
		string locale        = "",
		string excludeFields = "",
		string includeFields = ""
	){
		// Get validation manager
		var validationManager = variables.wirebox.getInstance( "ValidationManager@cbvalidation" );
		// validate constraints
		var thisConstraints   = "";

		if ( structKeyExists( this, "constraints" ) ) {
			thisConstraints = this.constraints;
		}

		// argument override
		if ( !isSimpleValue( arguments.constraints ) OR len( arguments.constraints ) ) {
			thisConstraints = arguments.constraints;
		}

		// validate and save results in private scope
		variables.validationResults = validationManager.validate(
			target        = this,
			fields        = arguments.fields,
			constraints   = thisConstraints,
			locale        = arguments.locale,
			excludeFields = arguments.excludeFields
		);

		// return it
		return ( !variables.validationResults.hasErrors() );
	}

	/**
	 * Get the validation results object.  This will be an empty validation object if isValid() has not being called yet.
	 *
	 * @return cbvalidation.models.result.IValidationResult
	 */
	any function getValidationResults(){
		if ( !isNull( variables.validationResults ) && isObject( variables.validationResults ) ) {
			return variables.validationResults;
		}
		return new cbvalidation.models.result.ValidationResult();
	}

	/**
	 * Validate the ActiveEntity with the coded constraints -> this.constraints,
	 * or passed in shared or implicit constraints
	 * The entity must have been populated with data before the validation
	 *
	 * This throws an exception if the validation fails. The validation errors will be in the exception extended information
	 *
	 * @fields        One or more fields to validate on, by default it validates all fields in the constraints. This can be a simple list or an array.
	 * @constraints   An optional shared constraints name or an actual structure of constraints to validate on.
	 * @locale        An optional locale to use for i18n messages
	 * @excludeFields An optional list of fields to exclude from the validation.
	 * @IncludeFields An optional list of fields to include in the validation.
	 *
	 * @return The entity back
	 *
	 * @throws ValidationException
	 */
	ActiveEntity function validateOrFail(
		string fields        = "*",
		any constraints      = "",
		string locale        = "",
		string excludeFields = "",
		string includeFields = ""
	){
		if ( !this.isValid( argumentCollection = arguments ) ) {
			throw(
				type         = "ValidationException",
				message      = "The active entity failed to pass validation",
				extendedInfo = getValidationResults().getAllErrorsAsJson()
			);
		}
		return this;
	}

}

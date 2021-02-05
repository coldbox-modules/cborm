/**
 * This base handler will inherit from the Base API Handler but actually implement it
 * for CRUD operations using ORM, cbORM and ColdBox Resources.
 *
 * ## Pre-Requisites
 *
 * - You will be injecting Virtual Entity services
 * - Your entities need to inherit from ActiveEntity
 * - You will need to register the routes using ColdBox <code>resources()</code> method
 * - You will need mementifier active
 *
 * ## Requirements
 *
 * In order for this to work, you will create a handler that inherits from this base
 * and make sure that you inject the appropriate virtual entity service using the variable name: <code>ormService</code>
 * Also populate the variables as needed
 *
 * <pre>
 * component extends="BaseOrmResource"{
 *
 * 		// Inject the correct virtual entity service to use
 * 		property name="ormService" inject="RoleService"
 * 		property name="ormService" inject="entityService:Permission"
 *
 * 		// The default sorting order string: permission, name, data desc, etc.
 * 		variables.sortOrder = "";
 * 		// The name of the entity this resource handler controls. Singular name please.
 * 		variables.entity 	= "Permission";
 * }
 * </pre>
 *
 * That's it!  All resource methods: <code>index, create, show, update, delete</code> will be implemented for you.
 * You can create more actions or override them as needed.
 */
component extends="coldbox.system.RestHandler" {

	/* *********************************************************************
	 **	DI
	 ********************************************************************* */

	property name="settings"    inject="coldbox:moduleSettings:cborm";
	property name="cbpaginator" inject="Pagination@cbpaginator";

	// The default sorting order string: permission, name, data desc, etc.
	variables.sortOrder = "";
	// The name of the entity this resource handler controls. Singular name please.
	variables.entity    = "";

	/**
	 * Display all resource records with pagination
	 * GET /api/v1/{resource}
	 *
	 * @criteria If you pass a criteria object, then we will use that instead of creating a new one
	 * @results If you pass in a results struct, it must contain the following: { count:numeric, records: array of objects }
	 */
	function index(
		event,
		rc,
		prc,
		criteria,
		struct results
	){
		// Memento params
		param rc.includes       = "";
		param rc.excludes       = "";
		param rc.ignoreDefaults = false;

		// Query params
		param rc.sortOrder = variables.sortOrder;
		param rc.page      = 1;
		param rc.isActive  = true;

		// If we do not have a criteria or we have results, create one
		if ( isNull( arguments.criteria ) && isNull( arguments.results ) ) {
			arguments.criteria = newCriteria();
		}

		// announce it
		announceInterception(
			"pre#variables.entity#List",
			{
				criteria : arguments.criteria ?: newCriteria(),
				results  : arguments.results ?: { "count" : 0, "records" : [] }
			}
		);

		// Run the results if no results passed
		if ( isNull( arguments.results ) ) {
			prc.recordCount = arguments.criteria.count();
			prc.records     = arguments.criteria.list(
				offset    = getPageOffset( rc.page ),
				max       = getMaxRows(),
				sortOrder = rc.sortOrder
			);
		} else {
			prc.recordCount = arguments.results.count;
			prc.records     = arguments.results.records;
		}

		// announce it
		announceInterception(
			"post#variables.entity#List",
			{
				count   : prc.recordCount,
				records : prc.records
			}
		);

		// Marshall out with Pagination information
		prc.response
			.setPagination(
				argumentCollection = variables.cbpaginator.generate(
					totalRecords = prc.recordCount,
					page         = rc.page,
					maxrows      = getMaxRows()
				)
			)
			.setData(
				prc.records.map( function( item ){
					return item.getMemento(
						includes       = rc.includes,
						excludes       = rc.excludes,
						ignoreDefaults = rc.ignoreDefaults
					);
				} )
			);
	}

	/**
	 * Create a resource
	 * POST /api/v1/{entity}
	 *
	 * @populate Population arguments
	 * @validate Validation arguments
	 */
	function create(
		event,
		rc,
		prc,
		struct populate = {},
		struct validate = {}
	){
		param rc.includes                             = "";
		param rc.excludes                             = "";
		param rc.ignoreDefaults                       = false;
		param arguments.populate.composeRelationships = true;

		// Population arguments
		arguments.populate.memento = rc;
		arguments.populate.model   = variables.ormService.new();

		// Validation Arguments
		arguments.validate.target = populateModel( argumentCollection = arguments.populate );

		// Validate
		prc.oEntity = validateOrFail( argumentCollection = arguments.validate );

		// announce it
		announceInterception(
			"pre#variables.entity#Save",
			{ entity : prc.oEntity }
		);

		// Save it
		variables.ormService.save( prc.oEntity );

		// announce it
		announceInterception(
			"post#variables.entity#Save",
			{ entity : prc.oEntity }
		);

		// Marshall it out
		prc.response.setData(
			prc.oEntity.getMemento(
				includes       = rc.includes,
				excludes       = rc.excludes,
				ignoreDefaults = rc.ignoreDefaults
			)
		);
	}

	/**
	 * Show a resource using the id
	 * GET /api/v1/{resource}/:id
	 */
	function show( event, rc, prc ){
		param rc.includes       = "";
		param rc.excludes       = "";
		param rc.ignoreDefaults = false;
		param rc.id             = 0;

		// announce it
		announceInterception( "pre#variables.entity#Show", {} );

		// Get by id
		prc.oEntity = variables.ormService.getOrFail( rc.id );

		// announce it
		announceInterception(
			"post#variables.entity#Show",
			{ entity : prc.oEntity }
		);

		// Marshall it
		prc.response.setData(
			prc.oEntity.getMemento(
				includes       = rc.includes,
				excludes       = rc.excludes,
				ignoreDefaults = rc.ignoreDefaults
			)
		);
	}

	/**
	 * Update a resource using an id
	 * PUT /api/v1/{resource}/:id
	 *
	 * @populate Population arguments
	 * @validate Validation arguments
	 */
	function update(
		event,
		rc,
		prc,
		struct populate = {},
		struct validate = {}
	){
		param rc.includes                             = "";
		param rc.excludes                             = "";
		param rc.ignoreDefaults                       = false;
		param rc.id                                   = 0;
		param arguments.populate.composeRelationships = true;

		// Population arguments
		arguments.populate.memento = rc;
		arguments.populate.model   = variables.ormService.getOrFail( rc.id );

		// Validation Arguments
		arguments.validate.target = populateModel( argumentCollection = arguments.populate );

		// Validate
		prc.oEntity = validateOrFail( argumentCollection = arguments.validate );

		// announce it
		announceInterception(
			"pre#variables.entity#Update",
			{ entity : prc.oEntity }
		);

		// Save it
		variables.ormService.save( prc.oEntity );

		// announce it
		announceInterception(
			"post#variables.entity#Update",
			{ entity : prc.oEntity }
		);

		// Marshall it out
		prc.response.setData(
			prc.oEntity.getMemento(
				includes       = rc.includes,
				excludes       = rc.excludes,
				ignoreDefaults = rc.ignoreDefaults
			)
		);
	}

	/**
	 * Delete a resource
	 * DELETE /api/v1/{resource}/:id
	 */
	function delete( event, rc, prc ){
		param rc.id = 0;

		prc.oEntity = variables.ormService.getOrFail( rc.id );

		// announce it
		announceInterception(
			"pre#variables.entity#Delete",
			{ entity : prc.oEntity }
		);

		variables.ormService.delete( prc.oEntity );

		// announce it
		announceInterception(
			"post#variables.entity#Delete",
			{ id : rc.id }
		);

		// Marshall it out
		prc.response.addMessage( "#variables.entity# deleted!" );
	}

	/******************************** PRIVATE FUNCTIONS ******************************/

	/**
	 * Calculate the starting offset for the incoming page
	 *
	 * @page The page to lookup on
	 *
	 * @return The page start offset
	 */
	private function getPageOffset( page = 1 ){
		var maxRows = getMaxRows();
		return ( arguments.page * maxrows - maxRows );
	}

	/**
	 * Get the max number of rows to retrieve according to global settings
	 * or passed in through RC
	 */
	private function getMaxRows( event = getRequestContext() ){
		var maxRows = event.getValue(
			"maxRows",
			variables.settings.resources.maxRows
		);
		// if limit = 0, then don't block
		if ( variables.settings.resources.maxRowsLimit == 0 ) {
			return maxRows;
		}
		// Else use limiter
		return (
			maxRows > variables.settings.resources.maxRowsLimit ? variables.settings.resources.maxRowsLimit
			 : maxRows
		);
	}

	/**
	 * Coverts a value to the correct javaType for the property passed in.
	 *
	 * @propertyName The property name
	 * @value The property value
	 */
	private function autoCast(
		required propertyName,
		required value
	){
		return variables.ormService.autoCast( argumentCollection = arguments );
	}

	/**
	 * Get a brand new criteria builder object
	 *
	 * @useQueryCaching Activate query caching for the list operations
	 * @queryCacheRegion The query cache region to use, which defaults to criterias.{entityName}
	 * @defaultAsQuery To return results as queries or array of objects or reports, default is array as results might not match entities precisely
	 *
	 * @return cborm.models.criterion.CriteriaBuilder
	 */
	private function newCriteria(
		boolean useQueryCaching = false,
		string queryCacheRegion = "",
		datasource
	){
		return variables.ormService.newCriteria( argumentCollection = arguments );
	}

}

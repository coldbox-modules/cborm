/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * ColdBox ORM enhancements for Hibernate
 */
component {

	// Module Properties
	this.title          = "cborm";
	this.author         = "Ortus Solutions";
	this.webURL         = "https://www.ortussolutions.com";
	this.description    = "ColdBox ORM enhancements for Hibernate";
	this.modelNamespace = "cborm";
	this.cfmapping      = "cborm";
	this.dependencies   = [
		"cbvalidation",
		"cbPaginator",
		"mementifier",
		"cbstreams"
	];

	variables.SETTING_DEFAULTS = {
		// Resource Settings
		resources : {
			// Enable the ORM Resource Event Loader
			eventLoader  : false,
			// Prefix to use on all the registered pre/post{Entity}{Action} events
			eventPrefix  : "",
			// Pagination max rows
			maxRows      : 25,
			// Pagination max row limit: 0 = no limit
			maxRowsLimit : 500
		},
		// WireBox Injection Bridge
		injection : { enabled : true, include : "", exclude : "" }
	};

	/**
	 * Configure Module
	 */
	function configure(){
		// cborm Settings
		settings = structCopy( variables.SETTING_DEFAULTS );

		// Register Custom DSL, don't map it because it is too late, mapping DSLs are only good by the parent app
		controller.getWireBox().registerDSL( namespace = "entityService", path = "#moduleMapping#.dsl.OrmDsl" );

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints : [
				// CriteriaBuilder Events
				"onCriteriaBuilderAddition",
				"beforeCriteriaBuilderList",
				"afterCriteriaBuilderList",
				"beforeCriteriaBuilderCount",
				"afterCriteriaBuilderCount",
				"afterCriteriaBuilderGet",
				"beforeCriteriaBuilderGet",
				"beforeOrmExecuteQuery",
				"afterOrmExecuteQuery",
				// ORM Bridge Events
				"ORMPostNew",
				"ORMPreLoad",
				"ORMPostLoad",
				"ORMPostDelete",
				"ORMPreDelete",
				"ORMPreUpdate",
				"ORMPostUpdate",
				"ORMPreInsert",
				"ORMPostInsert",
				"ORMPreSave",
				"ORMPostSave",
				"ORMPostFlush",
				"ORMPreFlush"
			]
		};

		// Custom Declared Interceptors
		interceptors = [];
	}

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){
		// Prepare setting defaults
		settings.resources.append( variables.SETTING_DEFAULTS.resources, false );
		settings.injection.append( variables.SETTING_DEFAULTS.injection, false );
		// Are we loading the event loader
		if ( settings.resources.eventLoader ) {
			wirebox.getInstance( "ResourceEventLoader@cborm" ).loadEvents();
		}
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
	}

}

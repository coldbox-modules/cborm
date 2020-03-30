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
	// Model Namespace
	this.modelNamespace = "cborm";
	// CF Mapping
	this.cfmapping      = "cborm";
	// Dependencies
	this.dependencies   = [ "cbvalidation", "cbPaginator" ];

	/**
	 * Configure Module
	 */
	function configure(){
		// cborm Settings
		settings = {
			// Resource Settings
			resources : {
				// Enable the ORM Resource Event Loader
				eventLoader 	: false,
				// Pagination max rows
				maxRows 		: 25,
				// Pagination max row limit: 0 = no limit
				maxRowsLimit 	: 500
			},
			// WireBox Injection Bridge
			injection : {
				enabled : true,
				include : "",
				exclude : ""
			}
		};

		// ColdBox 5 or 4 DSL Builder
		var dslPath = "#moduleMapping#.dsl.ORMDSL";
		if ( variables.keyExists( "coldboxVersion" ) ) {
			dslPath &= "5";
		}

		// Register Custom DSL, don't map it because it is too late, mapping DSLs are only good by the parent app
		controller.getWireBox().registerDSL( namespace = "entityService", path = dslPath );

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints : [
				// CriteriaBuilder Events
				"onCriteriaBuilderAddition",
				"beforeCriteriaBuilderList",
				"afterCriteriaBuilderList",
				"beforeCriteriaBuilderCount",
				"afterCriteriaBuilderCount",
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
		if( settings.resources.eventLoader ){
			wirebox.getInstance( "ResourceEventLoader@cborm" ).loadEvents();
		}
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
	}

}

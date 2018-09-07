/**
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ---
*/
component {

	// Module Properties
	this.title 				= "cborm";
	this.author 			= "Ortus Solutions";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "ColdBox ORM enhancements for Hibernate";
	// Model Namespace
	this.modelNamespace		= "cborm";
	// CF Mapping
	this.cfmapping			= "cborm";
	// Dependencies
	this.dependencies 		= [ "cbvalidation" ];

	/**
	* Configure Module
	*/
	function configure(){
		var dslPath = "#moduleMapping#.dsl.ORMDSL";
		// ColdBox 5
		if( variables.keyExists( "coldboxVersion" ) ){
			dslPath &= "5";
		}

		// Register Custom DSL, don't map it because it is too late, mapping DSLs are only good by the parent app
		controller.getWireBox()
			.registerDSL( namespace="entityService", path=dslPath );

		// Custom Declared Points
		interceptorSettings = {
			customInterceptionPoints = [
				// CriteriaBuilder Events
				"onCriteriaBuilderAddition", "beforeCriteriaBuilderList", "afterCriteriaBuilderList", "beforeCriteriaBuilderCount",
				"afterCriteriaBuilderCount",
				// ORM Bridge Events
				"ORMPostNew", "ORMPreLoad", "ORMPostLoad", "ORMPostDelete", "ORMPreDelete", "ORMPreUpdate", "ORMPostUpdate",
				"ORMPreInsert", "ORMPostInsert", "ORMPreSave", "ORMPostSave", "ORMPostFlush", "ORMPreFlush"
			]
		};

		// Custom Declared Interceptors
		interceptors = [
		];

	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// Read parent application config
		var oConfig = controller.getSetting( "ColdBoxConfig" );
		// Default Config Structure
		controller.setSetting( "orm", {
			injection = {
				enabled = true, include = "", exclude = ""
			}
		} );
		// Check if we have defined DSL first in application config
		var ormDsl = oConfig.getPropertyMixin( "orm", "variables", {} );
		// injection
		if( ormDsl.keyExists( "injection" ) ){
			structAppend( controller.getSetting( "orm" ).injection, ormDsl.injection, true);
		}
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){

	}

}

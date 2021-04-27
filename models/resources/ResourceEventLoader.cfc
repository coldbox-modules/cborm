/**
 * This  talks to hibernate an creates ColdBox interceptor events according to all the entities it finds
 * using the following format:
 *
 * - pre{entityName}List
 * - post{entityName}List
 * - pre{entityName}Save
 * - post{entityName}Save
 * - pre{entityName}Show
 * - post{entityName}Show
 * - pre{entityName}Update
 * - post{entityName}Update
 * - pre{entityName}Delete
 * - post{entityName}Delete
 */
component singleton {

	/* *********************************************************************
	 **	DI
	 ********************************************************************* */

	property name="log"                inject="logbox:logger:{this}";
	property name="interceptorService" inject="coldbox:interceptorService";
	property name="settings"           inject="coldbox:moduleSettings:cborm";

	/**
	 * Constructor
	 */
	function init(){
		return this;
	}

	/**
	 * Loads up all the events according to hibernate metadata
	 */
	function loadEvents(){
		var sTime = getTickCount();

		variables.log.info( "** Starting to register all Base ORM Resource Events" );

		// Register all Resource Events
		getEntityMap().each( function( thisEntity ){
			variables.interceptorService.appendInterceptionPoints( [
				"#variables.settings.eventPrefix#pre#thisEntity#List",
				"#variables.settings.eventPrefix#post#thisEntity#List",
				"#variables.settings.eventPrefix#pre#thisEntity#Save",
				"#variables.settings.eventPrefix#post#thisEntity#Save",
				"#variables.settings.eventPrefix#pre#thisEntity#Show",
				"#variables.settings.eventPrefix#post#thisEntity#Show",
				"#variables.settings.eventPrefix#pre#thisEntity#Update",
				"#variables.settings.eventPrefix#post#thisEntity#Update",
				"#variables.settings.eventPrefix#pre#thisEntity#Delete",
				"#variables.settings.eventPrefix#post#thisEntity#Delete"
			] );
			variables.log.info(
				"		===> Registered '#thisEntity#' resource events using event prefix of (#variables.settings.eventPrefix#)"
			);
		} );

		variables.log.info( "** Registered all Base ORM Resource Events in #getTickCount() - sTime# ms" );
	}

	/**
	 * Get the entity map according to engine
	 */
	private function getEntityMap(){
		if (
			find(
				"2018",
				server.coldfusion.productVersion
			)
		) {
			return arrayToList( ormGetSessionFactory().getMetaModel().getAllEntityNames() ).listToArray();
		} else {
			return structKeyArray( ormGetSessionFactory().getAllClassMetadata() );
		}
	};

}

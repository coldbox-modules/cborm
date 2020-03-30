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

	property name="log" 				inject="logbox:logger:{this}";
	property name="interceptorService" 	inject="coldbox:interceptorService";

	/**
	 * Constructor
	 */
	function init(){
		return this;
	}

	/**
	 * Loads up all the events according to hibernate
	 */
	function loadEvents(){
		var sTime = getTickCount();

		variables.log.info( "** Starting to register all Base ORM Resource Events" );

		// Register all Resource Events
		getEntityMap().each( function( thisEntity ){
			variables.interceptorService
				.appendInterceptionPoints( [
					"pre#thisEntity#List",
					"post#thisEntity#List",
					"pre#thisEntity#Save",
					"post#thisEntity#Save",
					"pre#thisEntity#Show",
					"post#thisEntity#Show",
					"pre#thisEntity#Update",
					"post#thisEntity#Update",
					"pre#thisEntity#Delete",
					"post#thisEntity#Delete"
				] );
			variables.log.info( "		===> Registered '#thisEntity#' Resource Events" );
		} );

		variables.log.info( "** Registered all Base ORM Resource Events in #getTickCount() - sTime# ms" );
	}

	/**
	 * Get the entity map according to engine
	 */
	private function getEntityMap(){
		if ( find( "2018", server.coldfusion.productVersion ) ) {
			return arrayToList( ormGetSessionFactory().getMetaModel().getAllEntityNames() ).listToArray();
		} else {
			return structKeyArray( ormGetSessionFactory().getAllClassMetadata() );
		}
	};

}

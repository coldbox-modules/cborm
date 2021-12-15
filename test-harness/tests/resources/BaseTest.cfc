/**
 * This is the ForgeBox Base Integration Test CFC
 * Place any helpers or traits for all integration tests here.
 */
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" {

	// Do not unload per test bundle to improve performance.
	this.unloadColdBox = false;

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
		getWireBox().autowire( this );

		var ormUtil = createMock( "cborm.models.util.ORMUtilSupport" );
		debug( "Hibernate version is: #ormUtil.getHibernateVersion()#" );
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
	}

	function reset(){
		// CB 6 graceful shutdown
		if ( !isNull( application.cbController ) ) {
			application.cbController.getLoaderService().processShutdown();
		}
		structDelete( application, "wirebox" );
		structDelete( application, "cbController" );
	}

	function withRollback( target ){
		transaction {
			try {
				arguments.target();
			} catch ( any e ) {
				rethrow;
			} finally {
				transaction action="rollback";
			}
		}
	}

	function isCF(){
		return ( structKeyExists( server, "lucee" ) ? false : true );
	}

	function isCF2018Plus(){
		if ( !structKeyExists( server, "lucee" ) && listFirst( server.coldfusion.productVersion ) >= 2018 ) {
			return true;
		}
		return false;
	}

}

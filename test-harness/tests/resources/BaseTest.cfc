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
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
		super.afterAll();
	}

	function withRollback( target ){
		transaction {
			try {
				arguments.target( argumentCollection = arguments );
			} catch ( any e ) {
				rethrow;
			} finally {
				transaction action="rollback";
			}
		}
	}

	function isCF(){
		return server.coldfusion.productname == "ColdFusion Server";
	}

	function notCF(){
		return !isCF();
	}

	function isLucee(){
		return server.keyExists( "lucee" );
	}

	function notLucee(){
		return !isLucee();
	}

	function isBoxLang(){
		return server.keyExists( "boxlang" );
	}

	function notBoxLang(){
		return !isBoxLang();
	}

	function isCF2018Plus(){
		if ( isCF() && listFirst( server.coldfusion.productVersion ) >= 2018 ) {
			return true;
		}
		return false;
	}

}

/**
 * This is the ForgeBox Base Integration Test CFC
 * Place any helpers or traits for all integration tests here.
 */
component extends="coldbox.system.testing.BaseTestCase" appMapping="/root" autowire {

	// Do not unload per test bundle to improve performance.
	this.unloadColdBox = false;

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		super.beforeAll();
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

	function notCF(){
		return !isAdobe();
	}

	function notLucee(){
		return !isLucee();
	}

	function notBoxLang(){
		return !isBoxLang();
	}

	function isCF2018Plus(){
		if ( isAdobe() && listFirst( server.coldfusion.productVersion ) >= 2018 ) {
			return true;
		}
		return false;
	}

}

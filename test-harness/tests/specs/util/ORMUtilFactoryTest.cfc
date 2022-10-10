/**
 * My BDD Test
 */
component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		factory = createMock( "cborm.models.util.ORMUtilFactory" );
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		// all your suites go here.
		describe( "ORM Util Factory", function(){
			it(
				title = "can get adobe instance",
				body  = function(){
					factory.$( "getPlatform", "ColdFusion Server" );
					var u = factory.getORMUtil();
					expect( u ).toBeInstanceOf( "cborm.models.util.CFORMUtil" );
				},
				skip = isLucee
			);

		} );
	}

	function isLucee(){
		return structKeyExists( server, "lucee" );
	}

}

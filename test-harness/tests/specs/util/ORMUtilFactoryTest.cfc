/**
 * My BDD Test
 */
component extends="tests.resources.BaseTest" {

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
		describe( "ORM Util Factory", function(){
			it(
				title = "can get adobe instance",
				body  = function(){
					var u = factory.getORMUtil();
					expect( u ).toBeInstanceOf( "cborm.models.util.support.CFORMUtil" );
				},
				skip = !isCF()
			);

			it(
				title = "can get lucee instance",
				body  = function(){
					factory.$( "getPlatform", "ColdFusion Server" );
					var u = factory.getORMUtil();
					expect( u ).toBeInstanceOf( "cborm.models.util.support.LuceeORMUtil" );
				},
				skip = !isLucee()
			);
		} );

	}

}

/**
* My BDD Test
*/
component extends="testbox.system.BaseSpec"{
	
/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		factory = createMock("cborm.model.util.ORMUtilFactory");
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		// all your suites go here.
		describe( "ORM Util Factory", function(){
			it( "can get adobe instance", function(){
				factory.$("getPlatform", "ColdFusion Server");
				var u = factory.getORMUtil();
				expect(	u ).toBeInstanceOf( "cborm.model.util.CFORMUtil" );
			});

			it( "can get railo < 4.3 instance", function(){
				factory.$("getPlatform", "railo" ).$("getRailoVersion", "4.1.000");
				var u = factory.getORMUtil();
				expect(	u ).toBeInstanceOf( "cborm.model.util.ORMUtil" );
			});

			it( "can get railo > 4.3 instance", function(){
				factory.$("getPlatform", "railo" ).$("getRailoVersion", "4.3.000");
				var u = factory.getORMUtil();
				expect(	u ).toBeInstanceOf( "cborm.model.util.RailoORMUtil" );
			});
		
		});
	}
	
}
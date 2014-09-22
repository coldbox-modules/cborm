/**
* My BDD Test
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all suites+specs in the run() method
	function beforeAll(){
		factory = createMock("cborm.models.util.ORMUtilFactory");
	}

	// executes after all suites+specs in the run() method
	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		// all your suites go here.
		describe( "ORM Util Factory", function(){

			it( title="can get adobe instance", body=function(){
				factory.$("getPlatform", "ColdFusion Server");
				var u = factory.getORMUtil();
				expect(	u ).toBeInstanceOf( "cborm.models.util.CFORMUtil" );
			}, skip=isRailo);

			it( "can get railo < 4.3 instance", function(){
				factory.$("getPlatform", "railo" ).$("getRailoVersion", "4.1.000");
				var u = factory.getORMUtil();
				expect(	u ).toBeInstanceOf( "cborm.models.util.ORMUtil" );
			});

			it( title="can get railo > 4.3 instance", body=function(){
				factory.$("getPlatform", "railo" ).$("getRailoVersion", "4.3.000");
				var u = factory.getORMUtil();
				expect(	u ).toBeInstanceOf( "cborm.models.util.RailoORMUtil" );
			}, skip=function(){
				return ( isRailo() and findNoCase( "4.3", server.railo.version ) ) ? false : true;
			});

		});
	}

	function isRailo(){
		return structKeyExists( server, "railo" );
	}
}
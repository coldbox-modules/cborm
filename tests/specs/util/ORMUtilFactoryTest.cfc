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
			}, skip=isLucee);

			it( "can get lucee < 4.3 instance", function(){
				factory.$("getPlatform", "railo" ).$("getLuceeVersion", "4.1.000");
				var u = factory.getORMUtil();
				expect(	u ).toBeInstanceOf( "cborm.models.util.ORMUtil" );
			});

			it( title="can get lucee > 4.3 instance", body=function(){
				factory.$("getPlatform", "lucee" ).$("getLuceeVersion", "4.3.000");
				var u = factory.getORMUtil();
				expect(	u ).toBeInstanceOf( "cborm.models.util.LuceeORMUtil" );
			}, skip=function(){
				return ( isLucee() and findNoCase( "4.3", server.lucee.version ) ) ? false : true;
			});

		});
	}

	function isLucee(){
		return structKeyExists( server, "lucee" );
	}
}
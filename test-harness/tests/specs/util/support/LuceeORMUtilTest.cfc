component extends="ORMUtilSupportTest" skip="notLucee" {

	function setup(){
		super.setup();
		ormUtil = createMock( "cborm.models.util.support.LuceeORMUtil" );
		// CF ENGINE MUST HAVE coolblog as a DSN
		dsn     = "coolblog";
	}

}

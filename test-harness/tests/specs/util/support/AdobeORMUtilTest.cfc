component extends="ORMUtilSupportTest" skip="notCF" {

	function setup(){
		super.setup();
		ormUtil = createMock( "cborm.models.util.support.AdobeORMUtil" );
		// CF ENGINE MUST HAVE coolblog as a DSN
		dsn     = "coolblog";
	}

}

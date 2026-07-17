component extends="ORMUtilSupportTest" skip="notBoxLang" {

	function setup(){
		super.setup();
		variables.ormUtil = createMock( "cborm.models.util.support.BoxLangORMUtil" );
		// CF ENGINE MUST HAVE coolblog as a DSN
		variables.dsn     = "coolblog";
	}

}

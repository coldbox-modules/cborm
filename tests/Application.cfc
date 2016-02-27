/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.coldbox.org | www.luismajano.com | www.ortussolutions.com | www.gocontentbox.org
**************************************************************************************
*/
component{
	this.name = "A TestBox Runner Suite " & hash( getCurrentTemplatePath() );
	// any other application.cfc stuff goes below:
	this.sessionManagement = true;

	// Turn on/off white space management
	this.whiteSpaceManagement = "smart";

	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/tests" ] 			= getDirectoryFromPath( getCurrentTemplatePath() );
	rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
	
	this.mappings[ "/root" ]   			= rootPath;
	this.mappings[ "/testbox" ]   		= rootPath & "/testbox";
	this.mappings[ "/cborm" ]   		= rootPath & "/modules/cborm";
	this.mappings[ "/cbi18n" ]   		= rootPath & "/modules/cbi18n";
	this.mappings[ "/cbvalidation" ]   	= rootPath & "/modules/cbvalidation";

	// Datasource definitions For Standalone mode/travis mode.
	if( findNoCase( "localhost:49616", cgi.htt_host ) ){
		this.datasources[ "coolblog" ] = {
			  class 			: 'org.gjt.mm.mysql.Driver',
			  connectionString	: 'jdbc:mysql://localhost:3306/coolblog?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true',
			  username 			: 'travis',
			  password 			: ''
		};
	
	}
	
	// ORM Definitions
	this.datasource = "coolblog";
	this.ormEnabled = "true";

	this.ormSettings = {
		cfclocation = [ "/root/models" ],
		logSQL = true,
		dbcreate = "update",
		secondarycacheenabled = false,
		cacheProvider = "ehcache",
		flushAtRequestEnd = false,
		eventhandling = true,
		eventHandler = "cborm.models.EventHandler",
		skipcfcWithError = false
	};

	// request start
	public boolean function onRequestStart( String targetPage ){
		ormreload();
		return true;
	}
}
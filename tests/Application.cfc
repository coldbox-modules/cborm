/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.coldbox.org | www.luismajano.com | www.ortussolutions.com | www.gocontentbox.org
**************************************************************************************
*/
component{
	this.name = "A TestBox Runner Suite " & hash( getCurrentTemplatePath() );
	// any other application.cfc stuff goes below:
	this.sessionManagement = true;

	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );
	rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
	this.mappings[ "/root" ]   = rootPath;
	this.mappings[ "/cborm" ]   = rootPath & "/modules/cborm";
	this.mappings[ "/cbi18n" ]   = rootPath & "/modules/cbi18n";
	this.mappings[ "/cbvalidation" ]   = rootPath & "/modules/cbvalidation";

	// any orm definitions go here.
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
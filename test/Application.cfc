/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.coldbox.org | www.luismajano.com | www.ortussolutions.com | www.gocontentbox.org
**************************************************************************************
*/
component{
	this.name = "CBORM Test Suite" & hash( getCurrentTemplatePath() );
	// any other application.cfc stuff goes below:
	this.sessionManagement = true;

	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/test" ] = getDirectoryFromPath( getCurrentTemplatePath() );
	rootPath = REReplaceNoCase( this.mappings[ "/test" ], "test(\\|/)", "" );
	this.mappings[ "/root" ]   = rootPath;
	this.mappings[ "/cborm" ]   = rootPath & "/modules/cborm";
	this.mappings[ "/cbvalidation" ]   = rootPath & "/modules/validation";

	this.datasource = "coolblog";
	this.ormEnabled = "true";

	this.ormSettings = {
		cfclocation = [ "/root/model" ],
		logSQL = true,
		dbcreate = "update",
		secondarycacheenabled = false,
		cacheProvider = "ehcache",
		flushAtRequestEnd = false,
		eventhandling = true,
		eventHandler = "cborm.model.EventHandler",
		skipcfcWithError = false
	};


	// request start
	public boolean function onRequestStart( String targetPage ){

		ormreload();
		return true;
	}
}
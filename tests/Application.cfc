/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.ortussolutions.com
* ---
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
	if( directoryExists( "/home/travis" ) ){
		this.datasources[ "coolblog" ] = {
			driver 				: "MySQL5",
			type 				: "mysql",
			connectionString	: 'jdbc:mysql://localhost:3306/coolblog?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true&',
			url					: 'jdbc:mysql://localhost:3306/coolblog?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true&',
			username			: 'root'
		};

		if( structKeyExists( server, "lucee" ) ){
			this.datasources[ "coolblog" ].class = 'org.gjt.mm.mysql.Driver';
		}
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
		if( StructKeyExists( server, "lucee" ) ){
			pagePoolClear();
		}
		return true;
	}

	public function onRequestEnd(){
		structDelete( application, "cbController" );
		structDelete( application, "wirebox" );
	}
}
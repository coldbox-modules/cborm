/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
*/
component {

	// UPDATE THE NAME OF THE MODULE IN TESTING BELOW
	request.MODULE_NAME = "cborm";
	request.MODULE_PATH = "cborm";

	// APPLICATION CFC PROPERTIES
	this.name               = "#request.MODULE_NAME# Testing Suite";
	this.sessionManagement  = true;
	this.sessionTimeout     = createTimespan( 0, 0, 30, 0 );
	this.applicationTimeout = createTimespan( 0, 0, 30, 0 );
	this.setClientCookies   = true;

	// Create testing mapping
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );

	// The application root
	rootPath = reReplaceNoCase(
		this.mappings[ "/tests" ],
		"tests(\\|/)",
		""
	);
	this.mappings[ "/root" ]         = rootPath;
	this.mappings[ "/cbvalidation" ] = rootPath & "/modules/cbvalidation";
	this.mappings[ "/cbi18n" ]       = rootPath & "/modules/cbvalidation/modules/cbi18n";
	this.mappings[ "/cbstreams" ]    = rootPath & "/modules/cbstreams";

	// The module root path
	moduleRootPath = reReplaceNoCase(
		rootPath,
		"#request.MODULE_PATH#(\\|/)test-harness(\\|/)",
		""
	);
	this.mappings[ "/moduleroot" ]            = moduleRootPath;
	this.mappings[ "/#request.MODULE_NAME#" ] = moduleRootPath & "#request.MODULE_PATH#";

	// ORM Definitions
	this.datasource  = "coolblog";
	this.ormEnabled  = "true";
	this.ormSettings = {
		cfclocation           : [ "/root/models" ],
		logSQL                : true,
		dbcreate              : "update",
		secondarycacheenabled : false,
		cacheProvider         : "ehcache",
		flushAtRequestEnd     : false,
		eventhandling         : true,
		eventHandler          : "cborm.models.EventHandler",
		skipcfcWithError      : false
	};

	// request start
	public boolean function onRequestStart( String targetPage ) {
		if ( url.keyExists( "fwreinit" ) ) {
			ormReload();
			if ( structKeyExists( server, "lucee" ) ) {
				pagePoolClear();
			}
		}

		return true;
	}

	public function onRequestEnd() {
		// CB 6 graceful shutdown
		if( !isNull( application.cbController ) ){
			application.cbController.getLoaderService().processShutdown();
		}

		structDelete( application, "cbController" );
		structDelete( application, "wirebox" );
	}

}

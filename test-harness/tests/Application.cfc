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
	rootPath                         = reReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
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
		dialect               : "org.hibernate.dialect.MySQL5InnoDBDialect",
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
	public boolean function onRequestStart( String targetPage ){
		// Set a high timeout for long running tests
		setting requestTimeout   ="9999";
		// New ColdBox Virtual Application Starter
		request.coldBoxVirtualApp= new coldbox.system.testing.VirtualApp( appMapping = "/root" );

		// ORM Reload for fresh results
		if ( structKeyExists( url, "fwreinit" ) ) {
			if ( structKeyExists( server, "lucee" ) ) {
				pagePoolClear();
			}
			ormReload();
			request.coldBoxVirtualApp.shutdown();
		}

		// If hitting the runner or specs, prep our virtual app
		if ( getBaseTemplatePath().replace( expandPath( "/tests" ), "" ).reFindNoCase( "(runner|specs)" ) ) {
			request.coldBoxVirtualApp.startup();
		}

		return true;
	}

	public function onRequestEnd(){
		request.coldBoxVirtualApp.shutdown();
	}

}

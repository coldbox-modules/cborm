component {

	// Configure ColdBox Application
	function configure(){
		// coldbox directives
		variables.coldbox = {
			// Application Setup
			appName                 : "Module Tester",
			// Development Settings
			reinitPassword          : "",
			handlersIndexAutoReload : true,
			modulesExternalLocation : [],
			// Implicit Events
			defaultEvent            : "",
			requestStartHandler     : "",
			requestEndHandler       : "",
			applicationStartHandler : "",
			applicationEndHandler   : "",
			sessionStartHandler     : "",
			sessionEndHandler       : "",
			missingTemplateHandler  : "",
			// Error/Exception Handling
			exceptionHandler        : "",
			onInvalidEvent          : "",
			customErrorTemplate     : "/coldbox/system/exceptions/Whoops.cfm",
			// Application Aspects
			handlerCaching          : false,
			eventCaching            : false
		};

		// environment settings, create a detectEnvironment() method to detect it yourself.
		// create a function with the name of the environment so it can be executed if that environment is detected
		// the value of the environment is a list of regex patterns to match the cgi.http_host.
		variables.environments = { development : "localhost,127\.0\.0\.1" };

		variables.interceptorSettings = {
			customInterceptionPoints : [
				// CriteriaBuilder Events
				"onCriteriaBuilderAddition",
				"beforeCriteriaBuilderList",
				"afterCriteriaBuilderList",
				"beforeCriteriaBuilderCount",
				"afterCriteriaBuilderCount",
				// ORM Bridge Events
				"ORMPostNew",
				"ORMPreLoad",
				"ORMPostLoad",
				"ORMPostDelete",
				"ORMPreDelete",
				"ORMPreUpdate",
				"ORMPostUpdate",
				"ORMPreInsert",
				"ORMPostInsert",
				"ORMPreSave",
				"ORMPostSave",
				"ORMPostFlush",
				"ORMPreFlush"
			]
		};

		// Register interceptors as an array, we need order
		interceptors = [];

		// LogBox DSL
		variables.logBox = {
			// Define Appenders
			appenders : {
				files : {
					class      : "coldbox.system.logging.appenders.RollingFileAppender",
					properties : {
						filename : "tester",
						filePath : "/#appMapping#/logs"
					}
				},
				console : { class : "coldbox.system.logging.appenders.ConsoleAppender" }
			},
			// Root Logger
			root  : { levelmax : "DEBUG", appenders : "*" },
			// Implicit Level Categories
			info  : [ "coldbox.system" ],
			debug : [ "cborm.*" ]
		};

		variables.moduleSettings = {
			cborm : {
				resources : {
					eventLoader : true
					// maxRows : 25,
					// maxRowsLimit : 250
				},
				injection : {
					enabled : true,
					include : "",
					exclude : ""
				}
			},
			mementifier : { ormAutoIncludes : true }
		};
	}

	/**
	 * Load the Module you are testing
	 */
	function afterAspectsLoad( event, interceptData, rc, prc ){
		controller
			.getModuleService()
			.registerAndActivateModule(
				moduleName     = request.MODULE_PATH,
				invocationPath = "moduleroot"
			)
	}

}

component extends="tests.resources.BaseTest" {

	function setup(){
		super.setup();
		variables.hTransaction = createMock( "cborm.aop.HibernateTransaction" ).init();

		// mocks
		variables.mockMapping = getMockBox().createEmptyMock( "coldbox.system.ioc.config.Mapping" );
		variables.mockLogger  = createEmptyMock( "coldbox.system.logging.Logger" )
			.$( "canDebug", false )
			.$( "error" );
		variables.hTransaction.setLog( mockLogger );
	}

	function testInvokeMethodInTransaction(){
		// default Datasource mock
		var md             = { name : "save", access : "public", transactional : "" };
		// mock invocation
		var mockInvocation = getMockBox()
			.createMock( "coldbox.system.aop.MethodInvocation" )
			.$( "proceed" )
			.init(
				"save",
				{ data : "Hello" },
				serializeJSON( md ),
				this,
				"Test",
				mockMapping,
				[]
			);

		// already in transaction
		request.cbox_aop_transaction = true;
		hTransaction.invokeMethod( mockInvocation );
		assertTrue( mockInvocation.$once( "proceed" ) );
		assertTrue( mockLogger.$once( "canDebug" ) );
	}

	function testInvokeMethodNotInTransaction(){
		// default Datasource mock
		var md             = { name : "save", access : "public", transactional : "" };
		// mock invocation
		var mockInvocation = getMockBox()
			.createMock( "coldbox.system.aop.MethodInvocation" )
			.$( "proceed" )
			.init(
				"save",
				{ data : "Hello" },
				serializeJSON( md ),
				this,
				"Test",
				mockMapping,
				[]
			);

		// not in transaction
		structDelete( request, "cbox_aop_transaction" );
		hTransaction.invokeMethod( mockInvocation );
		assertTrue( mockInvocation.$once( "proceed" ) );
		assertTrue( mockLogger.$once( "canDebug" ) );
	}

	function testInvokeMethodNotInTransactionDiffDatasource(){
		// With Datasource mock
		var md = {
			name          : "save",
			access        : "public",
			transactional : "coolblog"
		};
		// mock invocation
		var mockInvocation = getMockBox()
			.createMock( "coldbox.system.aop.MethodInvocation" )
			.$( "proceed" )
			.init(
				"save",
				{ data : "Hello" },
				serializeJSON( md ),
				this,
				"Test",
				mockMapping,
				[]
			);

		// not in transaction
		structDelete( request, "cbox_aop_transaction" );
		hTransaction.invokeMethod( mockInvocation );
		assertTrue( mockInvocation.$once( "proceed" ) );
		assertTrue( mockLogger.$once( "canDebug" ) );
	}

}

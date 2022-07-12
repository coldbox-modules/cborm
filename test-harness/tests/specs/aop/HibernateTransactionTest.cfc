/**
 * Skipping on ACF2018 due to a Hibernate but in 5.2.  Uncomment once they update Hibernate to 5.3+
 */
component extends="tests.resources.BaseTest" skip="isCF2018Plus" {

	function setup(){
		super.setup();
		hTransaction = createMock( "cborm.aop.HibernateTransaction" ).init();

		// mocks
		mockMapping = getMockBox().createEmptyMock( "coldbox.system.ioc.config.Mapping" );
		mockLogger  = createEmptyMock( "coldbox.system.logging.Logger" ).$( "canDebug", false ).$( "error" );
		hTransaction.setLog( mockLogger );
	}

	function testInvokeMethodInTransaction(){
		// default Datasource mock
		var md         = { name : "save", access : "public", transactional : "" };
		// mock invocation
		mockInvocation = getMockBox()
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
		var md         = { name : "save", access : "public", transactional : "" };
		// mock invocation
		mockInvocation = getMockBox()
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
		mockInvocation = getMockBox()
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

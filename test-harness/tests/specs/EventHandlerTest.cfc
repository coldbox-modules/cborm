component extends="tests.resources.BaseTest" {

	function beforeTests() {
		super.beforeTests();
		// Load our test injector for ORM entity binding
		new coldbox.system.ioc.Injector( binder = "tests.resources.WireBox" );
	}

	function setup() {
		testUserID = "88B73A03-FEFA-935D-AD8036E1B7954B76";
	}

	function testInjection() {
		var user = entityLoad( "ActiveUser", testUserID, true );
		// debug( user );
		assertTrue( isObject( user.getWireBox() ) );
	}

}

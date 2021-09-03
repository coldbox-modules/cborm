component extends="coldbox.system.testing.BaseInterceptorTest" interceptor="root.interceptors.ORMListener" {

	function setup(){
		super.setup();
	}

	function testORMPreload(){
		var entity = entityLoad( "User" );
		assertTrue( arrayLen( mockEventHandler.$callLog().ORMPreLoad ) );
	}

	function testORMPreload(){
		var entity = entityLoad( "User" );
		assertTrue( arrayLen( mockEventHandler.$callLog().ORMPostLoad ) );
	}

}

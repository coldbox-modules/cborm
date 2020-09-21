component extends="tests.resources.BaseTest" skip="isCF" {

	this.loadColdBox = false;

	function isCF() {
		// skip tests for Adobe, this is a railo only suite
		return ( structKeyExists( server, "railo" ) ? false : true );
	}

	function setup() {
		ormUtil = getMockBox().createMock( "cborm.models.util.ORMUtil" );
	}

	function testflush() {
		ormutil.flush();
	}

	function testGetSession() {
		t = ormutil.getSession();
	}

	function testgetSessionFactory() {
		t = ormutil.getSessionFactory();
	}

	function testclearSession() {
		t = ormutil.clearSession();
	}

	function testcloseSession() {
		t = ormutil.closeSession();
	}

	function testevictQueries() {
		t = ormutil.evictQueries();
		t = ormutil.evictQueries( "users" );
	}

	function testGetEntityDatasource() {
		d = ormutil.getEntityDatasource( "User" );
		assertEquals( "coolblog", d );

		d = ormutil.getEntityDatasource( entityNew( "User" ) );
		assertEquals( "coolblog", d );

		d = ormutil.getEntityDatasource( entityNew( "Category" ) );
		assertEquals( "coolblog", d );
	}

	function testGetDefaultDatasource() {
		assertEquals( "coolblog", ormutil.getDefaultDatasource() );
	}

}

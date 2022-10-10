component extends="tests.resources.BaseTest" skip="isLucee" {

	function setup(){
		super.setup();
		ormUtil = getMockBox().createMock( "cborm.models.util.CFORMUtil" );
		// CF ENGINE MUST HAVE coolblog as a DSN
		dsn     = "coolblog";
	}

	function testflush(){
		ormutil.flush();
		ormutil.flush( dsn );
	}

	function testGetSession(){
		t = ormutil.getSession();
		t = ormutil.getSession( dsn );
	}

	function testgetSessionFactory(){
		t = ormutil.getSessionFactory();
		t = ormutil.getSessionFactory( dsn );
	}

	function testclearSession(){
		t = ormutil.clearSession();
		t = ormutil.clearSession( dsn );
	}

	function testcloseSession(){
		t = ormutil.closeSession();
		t = ormutil.closeSession( dsn );
	}

	function testevictQueries(){
		t = ormutil.evictQueries();
		t = ormutil.evictQueries( "users" );
		t = ormutil.evictQueries( "users", dsn );
	}

	function testGetEntityDatasource(){
		d = ormutil.getEntityDatasource( "User" );
		assertEquals( "coolblog", d );

		d = ormutil.getEntityDatasource( entityNew( "User" ) );
		assertEquals( "coolblog", d );

		d = ormutil.getEntityDatasource( entityNew( "Category" ) );
		assertEquals( "coolblog", d );
	}

	function testGetDefaultDatasource(){
		assertEquals( "coolblog", ormutil.getDefaultDatasource() );
	}

	function isLucee(){
		return structKeyExists( server, "lucee" );
	}

	function testGetHibernateVersion(){
		debug( ormutil.getHibernateVersion() );

		// Fragile test: These will need updating if (and only if) the engines upgrade the installed Hibernate version
		if ( listFirst( server.coldfusion.productVersion ) == 2018 ) {
			assertEquals( "5.2.11.SNAPSHOT", ormutil.getHibernateVersion() );
		}
	}

}

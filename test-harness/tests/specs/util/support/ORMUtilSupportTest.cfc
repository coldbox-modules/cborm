component extends="tests.resources.BaseTest" skip="true"{

	function testIsInTransaction(){
		assertEquals( false, ormutil.isInTransaction(), "no transaction" );

		transaction {
			assertEquals( true, ormutil.isInTransaction(), "simple transaction" );
		}

		assertEquals( false, ormutil.isInTransaction(), "outside transaction" );

		transaction {
			ormGetSession();
			var test = entityLoad( "User", { firstName : "Luis" }, true );
			assertEquals( true, ormutil.isInTransaction(), "second transaction" );
			ormFlush();
			assertEquals( true, ormutil.isInTransaction(), "second transaction" );
		}

		ormFlush();
		assertEquals( false, ormutil.isInTransaction()  );
	}

	function testflush(){
		ormutil.flush();
		ormutil.flush( dsn );
	}

	function testGetSession(){
		t = ormutil.getSession();
		expect( t ).notToBeNull();
		t = ormutil.getSession( dsn );
		expect( t ).notToBeNull();
	}

	function testgetSessionFactory(){
		t = ormutil.getSessionFactory();
		expect( t ).notToBeNull();
		t = ormutil.getSessionFactory( dsn );
		expect( t ).notToBeNull();
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

	function testgetHibernateVersion(){
		t = ormutil.getHibernateVersion();
		debug( t );
		expect( t ).notToBeEmpty();
	}

}

component extends="tests.resources.BaseTest" skip="isCF" {

	function setup(){
		ormUtil = getMockBox().createMock( "cborm.models.util.LuceeORMUtil" );
	}

	function testflush(){
		ormutil.flush();
	}

	function testGetSession(){
		t = ormutil.getSession();
	}

	function testgetSessionFactory(){
		t = ormutil.getSessionFactory();
	}

	function testclearSession(){
		t = ormutil.clearSession();
	}

	function testcloseSession(){
		t = ormutil.closeSession();
	}

	function testevictQueries(){
		t = ormutil.evictQueries();
		t = ormutil.evictQueries( "users" );
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

	function testGetHibernateVersion(){
		debug( ormutil.getHibernateVersion() );
		/**
		 * ! LUCEE-ONLY
		 */
		var hibernateExtension = extensionList().filter( function( extension ){
			return extension.name == "Hibernate ORM Engine";
		} );
		if ( listContains( hibernateExtension.version, "5.4.29" ) > 0 ) {
			assertEquals( "5.4.29.1", ormutil.getHibernateVersion() );
		} else {
			assertEquals( "3.5.5-Final", ormutil.getHibernateVersion() );
		}
	}

}

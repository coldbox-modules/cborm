component extends="tests.resources.BaseTest" {

	function setup(){
		ormUtil = getMockBox().createMock( "cborm.models.util.ORMUtilSupport" );
	}

	function testIsInTransaction(){
		assertEquals( ormutil.isInTransaction(), false );

		transaction {
			assertEquals( ormutil.isInTransaction(), true );
		}

		assertEquals( ormutil.isInTransaction(), false );

		transaction {
			ormGetSession();
			test = entityLoad( "User", { firstName : "Luis" }, true );
			assertEquals( ormutil.isInTransaction(), true );
			ormFlush();
			assertEquals( ormutil.isInTransaction(), true );
		}

		ormFlush();
		assertEquals( ormutil.isInTransaction(), false );
	}

}

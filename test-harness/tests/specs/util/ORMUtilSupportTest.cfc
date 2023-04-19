component extends="tests.resources.BaseTest" {

	function setup(){
		variables.ormUtil = createMock( "cborm.models.util.ORMUtilSupport" );
	}

	function testIsInTransaction(){
		assertEquals( ormutil.isInTransaction(), false );

		transaction {
			assertEquals( ormutil.isInTransaction(), true );
		}

		assertEquals( ormutil.isInTransaction(), false );

		transaction {
			ormGetSession();
			var test = entityLoad( "User", { firstName : "Luis" }, true );
			assertEquals( ormutil.isInTransaction(), true );
			ormFlush();
			assertEquals( ormutil.isInTransaction(), true );
		}

		ormFlush();
		assertEquals( ormutil.isInTransaction(), false );
	}

}

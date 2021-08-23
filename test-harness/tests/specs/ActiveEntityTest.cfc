component extends="tests.resources.BaseTest" {

	function beforeTests(){
		super.beforeTests();
	}

	function setup(){
		ormCloseSession();
		ormClearSession();

		super.setup();
		// If Lucee, close the current ORM session to avoid stackoverflow bug
		activeUser = getMockBox().prepareMock( entityNew( "ActiveUser" ) );

		// Test ID's
		testUserID = "88B73A03-FEFA-935D-AD8036E1B7954B76";
		testCatID  = "3A2C516C-41CE-41D3-A9224EA690ED1128";
	}

	function testCountByDynamically(){
		// Test simple Equals
		t = activeUser.countByLastName( "majano" );
		assert( 1 eq t, "CountBylastName" );
	}
	function testFindByDynamically(){
		t = activeUser.findAllByLastNameLessThanEquals( "Majano" );
		assert(
			arrayLen( t ),
			"Conditionals LessThanEquals"
		);
		// Test simple Equals
		t = activeUser.findByLastName( "majano" );
		assert( isObject( t ), "FindBylastName" );
		// Test simple Equals with invalid
		t = activeUser.findByLastName( "d" );
		assert( isNull( t ), "Invalid last name" );
		// Using Conditionals
		t = activeUser.findAllByLastNameLessThan( "Majano" );
		assert(
			arrayLen( t ),
			"Conditionals LessThan"
		);
		t = activeUser.findAllByLastNameGreaterThan( "Majano" );
		assert(
			arrayLen( t ),
			"Conditionals GreaterThan"
		);
		t = activeUser.findAllByLastNameGreaterThanEquals( "Majano" );
		assert(
			arrayLen( t ),
			"Conditionals GreaterThanEqauls"
		);
		t = activeUser.findByLastNameLike( "ma%" );
		assert( isObject( t ), "Conditionals Like" );
		t = activeUser.findAllByLastNameNotEqual( "Majano" );
		assert( arrayLen( t ), "Conditionals Equal" );
		t = activeUser.findByLastNameIsNull();
		assert( isNull( t ), "Conditionals isNull" );
		t = activeUser.findAllByLastNameIsNotNull();
		assert( arrayLen( t ), "Conditionals isNull" );
		t = activeUser.findAllByLastLoginBetween( "01/01/2009", "01/01/2012" );
		assert(
			arrayLen( t ),
			"Conditionals between"
		);
		t = activeUser.findByLastLoginBetween( "01/01/2008", "11/01/2008" );
		assert( isNull( t ), "Conditionals between" );
		t = activeUser.findAllByLastLoginNotBetween( "01/01/2009", "01/01/2012" );
		assert(
			arrayLen( t ),
			"Conditionals not between"
		);
		t = activeUser.findAllByLastNameInList( "Majano,Fernando" );
		assert( arrayLen( t ), "Conditionals inList" );
		t = activeUser.findAllByLastNameInList( listToArray( "Majano,Fernando" ) );
		assert( arrayLen( t ), "Conditionals inList" );
		t = activeUser.findAllByLastNameNotInList( listToArray( "Majano,Fernando" ) );
		assert(
			arrayLen( t ),
			"Conditionals NotinList"
		);
	}

	function testFindByDynamicallyBadProperty(){
		expectException( "InvalidMethodGrammar" );
		t = activeUser.findByLastAndFirst();
	}

	function testFindByDynamicallyFailure(){
		expectException( "HQLQueryException" );
		t = activeUser.findByLastName();
	}

	function testIsValid(){
		r = activeUser.isValid();
		assertFalse( r );

		activeUser.setFirstName( "Luis" );
		activeUser.setLastName( "Majano" );
		activeUser.setUsername( "LuisMajano" );
		activeUser.setPassword( "LuisMajano" );
		r = activeUser.isValid();
		assertTrue( r );
	}

	function testValidateOrFail(){
		activeUser.setFirstName( "Luis" );
		activeUser.setLastName( "Majano" );
		activeUser.setPassword( "LuisMajano" );
		expect( function(){
			activeUser.validateOrFail();
		} ).toThrow();
	}

	function testValidationResults(){
		r = activeUser.getValidationResults();
		expect( r.hasErrors() ).toBeFalse();
	}

	function testNew(){
		user = activeUser.new();
		assertFalse( isNull( user ) );

		user = activeUser.new(
			properties = {
				firstName : "Luis",
				lastName  : "UnitTest"
			}
		);
		assertEquals( "Luis", user.getFirstName() );
	}

	function testGet(){
		user = activeUser.get( "123" );
		assertTrue( isNull( user ) );

		user = activeUser.get( testUserID );
		assertEquals( testUserID, user.getID() );
	}

	function testGetAll(){
		r = activeUser.getAll();
		assertTrue( arrayLen( r ) );

		r = activeUser.getAll( [ 1, 2 ] );
		assertFalse( arrayLen( r ) );

		r = activeUser.getAll( testUserID );
		assertTrue( isObject( r[ 1 ] ) );

		r = activeUser.getAll( [ testUserID, testUserID ] );
		assertTrue( isObject( r[ 1 ] ) );
	}

	function testSave(){
		// mocks
		mockEventHandler = getMockBox().createEmptyMock( "cborm.models.EventHandler" );
		mockEventHandler.$( "preSave" );
		mockEventHandler.$( "postSave" );

		user = getMockBox().prepareMock( entityNew( "ActiveUser" ) );
		user.$property(
			"ORMEventHandler",
			"variables",
			mockEventHandler
		);
		user.setFirstName( "unitTest" );
		user.setLastName( "unitTest" );
		user.setUsername( "unitTest" );
		user.setPassword( "unitTest" );

		transaction {
			try {
				user.save( transactional = false );
				assertTrue( len( user.getID() ) );
				assertTrue( arrayLen( mockEventHandler.$callLog().preSave ) );
				assertTrue( arrayLen( mockEventHandler.$callLog().postSave ) );
			} catch ( any e ) {
				fail( e.detail & e.message );
			} finally {
				transactionRollback();
			}
		}
	}

	function testDelete(){
		// Create test record to delete
		var user = entityNew( "ActiveUser" );
		user.setFirstName( "unitTest" );
		user.setLastName( "unitTest" );
		user.setUsername( "unitTest" );
		user.setPassword( "unitTest" );
		entitySave( user );
		ormFlush();

		try {
			user.delete();
			ormFlush();

			// Clear the session just in case to make sure we try and load the deleted entity
			ormClearSession();
			ormCloseSession();

			var q       = new Query( sql = "select * from users where firstName = 'unitTest'" );
			var results = q.execute().getResult();
			expect( results.recordcount ).toBe( 0 );
		} catch ( any e ) {
			fail( e.detail & e.message );
		} finally {
			var q = new Query( datasource = "coolblog" );
			q.execute( sql = "delete from users where firstName = 'unitTest'" );
		}
	}

	function testDeleteByID(){
		// Create test record to delete
		var user = entityNew( "ActiveUser" );
		user.setFirstName( "unitTest" );
		user.setLastName( "unitTest" );
		user.setUsername( "unitTest" );
		user.setPassword( "unitTest" );
		entitySave( user );
		ormFlush();

		try {
			activeUser.deleteByID( user.getID() );
			ormFlush();

			// Clear the session just in case to make sure we try and load the deleted entity
			ormClearSession();
			ormCloseSession();

			// Try to load
			var q       = new Query( sql = "select * from users where firstName = 'unitTest'" );
			var results = q.execute().getResult();
			expect( results.recordcount ).toBe( 0 );
		} catch ( any e ) {
			fail( e.detail & e.message );
		} finally {
			var q = new Query( datasource = "coolblog" );
			q.execute( sql = "delete from users where firstName = 'unitTest'" );
		}
	}

	function testDeleteWhere(){
		for ( var x = 1; x lte 3; x++ ) {
			user = entityNew( "ActiveUser" );
			user.setFirstName( "unitTest#x#" );
			user.setLastName( "unitTest" );
			user.setUsername( "unitTest" );
			user.setPassword( "unitTest" );
			entitySave( user );
		}
		ormFlush();
		q = new Query( datasource = "coolblog" );

		try {
			if ( structKeyExists( server, "lucee" ) ) {
				ormCloseSession();
			}
			activeUser.deleteWhere( userName = "unitTest" );
			ormFlush();
			user.clear();

			result = q.execute( sql = "select * from users where userName = 'unitTest'" );
			assertEquals( 0, result.getResult().recordcount );
		} catch ( any e ) {
			fail( e.detail & e.message & e.stackTrace );
		} finally {
			q.execute( sql = "delete from users where userName = 'unitTest'" );
		}
	}

	function testCount(){
		count = activeUser.count();
		assertTrue( count gt 0 );

		count = activeUser.count( "firstname='luis'" );
		assertEquals( 1, count );
	}

	function testList(){
		test = activeUser.list( sortorder = "lastName asc" );

		assertTrue( isArray( test ) );
		assertTrue( arrayLen( test ) );
	}

	function testFindWhere(){
		test = activeUser.findWhere( { firstName : "Luis" } );
		assertEquals( "Majano", test.getLastName() );
	}

	function testFindAllWhere(){
		test = activeUser.findAllWhere( { firstName : "Luis" } );
		assertEquals( 1, arrayLen( test ) );
	}


	function testGetKey(){
		test = activeUser.getKey( entityName = "User" );
		assertEquals( "id", test );
	}

	function testGetPropertyNames(){
		test = activeUser.getPropertyNames( entityName = "User" );
		assertEquals( 6, arrayLen( test ) );
	}

	function testGetTableName(){
		test = activeUser.getTableName();
		assertEquals( "users", test );
	}

	function testNewCriteria(){
		c = activeUser.newCriteria();
		assertEquals( "ActiveUser", c.getEntityName() );
	}

	function testIsDirty(){
		user = activeUser.new(
			properties = {
				firstName : "Some",
				lastName  : "Person",
				username  : "unittest",
				password  : "password"
			}
		);

		transaction {
			try {
				assertFalse( user.isDirty() );
				user.save( flush = true, transactional = false );
				assertFalse( user.isDirty() );
				user.setFirstname( "Another" );
				user.setLastname( "Person" );
				assertTrue( user.isDirty() );
			} catch ( any e ) {
				fail( e.detail & e.message );
			} finally {
				transactionRollback();
			}
		}
	}

	private function deleteCategories(){
		var q = new Query( datasource = "coolblog" );
		q.execute( sql = "delete from categories where category = 'unitTest'" );
	}

}

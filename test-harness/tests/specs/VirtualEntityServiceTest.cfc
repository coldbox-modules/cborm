component extends="tests.resources.BaseTest" {

	function beforeTests(){
		super.beforeTests();
		// Load our test injector for ORM entity binding
	}

	function setup(){
		variables.ormservice = createMock( "cborm.models.VirtualEntityService" );
		// Mocks
		variables.ormservice.init( entityname = "User" );

		// Test ID's
		variables.testUserID = "88B73A03-FEFA-935D-AD8036E1B7954B76";
		variables.testCatID  = "3A2C516C-41CE-41D3-A9224EA690ED1128";
	}

	function testCountByDynamically(){
		// Test simple Equals
		var t = ormservice.init( "User" ).countByLastName( "majano" );
		assert( 1 eq t, "CountBylastName" );
	}
	function testFindByDynamically(){
		// Test simple Equals
		var t = ormservice.findByLastName( "majano" );
		assert( isObject( t ), "FindBylastName" );
		// Test simple Equals with invalid
		var t = ormservice.findByLastName( "d" );
		assert( isNull( t ), "Invalid last name" );
		// Using Conditionals
		var t = ormservice.findAllByLastNameLessThanEquals( "Majano" );
		assert( arrayLen( t ), "Conditionals LessThanEquals" );
		var t = ormservice.findAllByLastNameLessThan( "Majano" );
		assert( arrayLen( t ), "Conditionals LessThan" );
		var t = ormservice.findAllByLastNameGreaterThan( "Majano" );
		assert( arrayLen( t ), "Conditionals GreaterThan" );
		var t = ormservice.findAllByLastNameGreaterThanEquals( "Majano" );
		assert( arrayLen( t ), "Conditionals GreaterThanEqauls" );
		var t = ormservice.findByLastNameLike( "ma%" );
		assert( isObject( t ), "Conditionals Like" );
		var t = ormservice.findAllByLastNameNotEqual( "Majano" );
		assert( arrayLen( t ), "Conditionals Equal" );
		var t = ormservice.findByLastNameIsNull();
		assert( isNull( t ), "Conditionals isNull" );
		var t = ormservice.findAllByLastNameIsNotNull();
		assert( arrayLen( t ), "Conditionals isNull" );
		var t = ormservice.findAllByLastLoginBetween( "01/01/2009", "01/01/2012" );
		assert( arrayLen( t ), "Conditionals between" );
		var t = ormservice.findByLastLoginBetween( "01/01/2008", "11/01/2008" );
		assert( isNull( t ), "Conditionals between" );
		var t = ormservice.findAllByLastNameInList( "Majano,Fernando" );
		assert( arrayLen( t ), "Conditionals inList" );
		var t = ormservice.findAllByLastNameInList( listToArray( "Majano,Fernando" ) );
		assert( arrayLen( t ), "Conditionals inList" );
		var t = ormservice.findAllByLastNameNotInList( listToArray( "Majano,Fernando" ) );
		assert( arrayLen( t ), "Conditionals NotinList" );
	}

	function testFindByDynamicallyBadProperty(){
		expectException( "InvalidMethodGrammar" );
		var t = ormservice.findByLastAndFirst();
	}

	function testFindByDynamicallyFailure(){
		expectException( "HQLQueryException" );
		var t = ormservice.findByLastName();
	}


	function testNew(){
		var user = ormservice.new();
		assertFalse( isNull( user ) );

		var user = ormService.new( properties = { firstName : "Luis", lastName : "UnitTest" } );
		assertEquals( "Luis", user.getFirstName() );
	}

	function testGet(){
		var user = ormService.get( "123" );
		assertTrue( isNull( user ) );

		var user = ormService.get( testUserID );
		assertEquals( testUserID, user.getID() );
	}

	function testGetAll(){
		var r = ormService.getAll();
		assertTrue( arrayLen( r ) );

		var r = ormService.getAll( [ 1, 2 ] );
		assertFalse( arrayLen( r ) );

		var r = ormService.getAll( testUserID );
		assertTrue( isObject( r[ 1 ] ) );

		var r = ormService.getAll( [ testUserID, testUserID ] );
		assertTrue( isObject( r[ 1 ] ) );
	}

	function testDeleteByID(){
		var user = entityNew( "User" );
		user.setFirstName( "unitTest" );
		user.setLastName( "unitTest" );
		user.setUsername( "unitTest" );
		user.setPassword( "unitTest" );
		entitySave( user );
		ormFlush();

		try {
			ormservice.deleteByID( user.getID() );
			var user = entityLoad( "User", { firstName : "unittest" }, true );
			assertTrue( isNull( user ) );
		} catch ( any e ) {
			rethrow;
		} finally {
			queryExecute( "delete from users where firstName = 'unitTest'" );
		}
	}

	function testDeleteWhere(){
		for ( var x = 1; x lte 3; x++ ) {
			var user = entityNew( "User" );
			user.setFirstName( "unitTest#x#" );
			user.setLastName( "unitTest" );
			user.setUsername( "unitTest" );
			user.setPassword( "unitTest" );
			entitySave( user );
		}
		ormFlush();

		try {
			ormService.deleteWhere( userName = "unitTest" );

			var result = queryExecute( "select * from users where userName = 'unitTest'" );
			assertEquals( 0, result.recordcount );
		} catch ( any e ) {
			rethrow;
		} finally {
			queryExecute( "delete from users where userName = 'unitTest'" );
		}
	}

	function testCount(){
		var count = ormService.count();
		assertTrue( count gt 0 );

		var count = ormService.count( "firstname='luis'" );
		assertEquals( 1, count );
	}

	function testList(){
		var test = ormservice.list( sortorder = "lastName asc" );

		assertTrue( isArray( test ) );
		assertTrue( arrayLen( test ) );
	}

	function testFindWhere(){
		var test = ormservice.findWhere( { firstName : "Luis" } );
		assertEquals( "Majano", test.getLastName() );
	}

	function testFindAllWhere(){
		var test = ormservice.findAllWhere( { firstName : "Luis" } );
		assertEquals( 1, arrayLen( test ) );
	}


	function testGetKey(){
		var test = ormservice.getKey( entityName = "User" );
		assertEquals( "id", test );
	}

	function testGetPropertyNames(){
		var test = ormservice.getPropertyNames( entityName = "User" );
		assertEquals( 6, arrayLen( test ) );
	}

	function testGetTableName(){
		var test = ormservice.getTableName();
		assertEquals( "users", test );
	}

	function testNewCriteria(){
		var c = ormservice.newCriteria();
		assertEquals( "User", c.getEntityName() );
	}

	function testConvertIDValueToJavaType(){
		var test = ormservice.convertIDValueToJavaType( id = 1 );
		assertEquals( [ 1 ], test );

		var test = ormservice.convertIDValueToJavaType( id = [ "1", "2", "3" ] );
		assertEquals( [ 1, 2, 3 ], test );
	}

	function testConvertValueToJavaType(){
		var test = ormservice.convertValueToJavaType( propertyName = "id", value = testUserID );
		assertEquals( testUserID, test );
	}

}

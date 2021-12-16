﻿component extends="tests.resources.BaseTest" {

	function beforeTests(){
		super.beforeTests();
		// Load our test injector for ORM entity binding
	}

	function setup(){
		ormservice = getMockBox().createMock( "cborm.models.VirtualEntityService" );
		// Mocks
		ormservice.init( entityname = "User" );

		// Test ID's
		testUserID = "88B73A03-FEFA-935D-AD8036E1B7954B76";
		testCatID  = "3A2C516C-41CE-41D3-A9224EA690ED1128";
	}

	function testCountByDynamically(){
		// Test simple Equals
		t = ormservice.init( "User" ).countByLastName( "majano" );
		assert( 1 eq t, "CountBylastName" );
	}
	function testFindByDynamically(){
		// Test simple Equals
		t = ormservice.findByLastName( "majano" );
		assert( isObject( t ), "FindBylastName" );
		// Test simple Equals with invalid
		t = ormservice.findByLastName( "d" );
		assert( isNull( t ), "Invalid last name" );
		// Using Conditionals
		t = ormservice.findAllByLastNameLessThanEquals( "Majano" );
		assert( arrayLen( t ), "Conditionals LessThanEquals" );
		t = ormservice.findAllByLastNameLessThan( "Majano" );
		assert( arrayLen( t ), "Conditionals LessThan" );
		t = ormservice.findAllByLastNameGreaterThan( "Majano" );
		assert( arrayLen( t ), "Conditionals GreaterThan" );
		t = ormservice.findAllByLastNameGreaterThanEquals( "Majano" );
		assert( arrayLen( t ), "Conditionals GreaterThanEqauls" );
		t = ormservice.findByLastNameLike( "ma%" );
		assert( isObject( t ), "Conditionals Like" );
		t = ormservice.findAllByLastNameNotEqual( "Majano" );
		assert( arrayLen( t ), "Conditionals Equal" );
		t = ormservice.findByLastNameIsNull();
		assert( isNull( t ), "Conditionals isNull" );
		t = ormservice.findAllByLastNameIsNotNull();
		assert( arrayLen( t ), "Conditionals isNull" );
		t = ormservice.findAllByLastLoginBetween( "01/01/2009", "01/01/2012" );
		assert( arrayLen( t ), "Conditionals between" );
		t = ormservice.findByLastLoginBetween( "01/01/2008", "11/01/2008" );
		assert( isNull( t ), "Conditionals between" );
		t = ormservice.findAllByLastNameInList( "Majano,Fernando" );
		assert( arrayLen( t ), "Conditionals inList" );
		t = ormservice.findAllByLastNameInList( listToArray( "Majano,Fernando" ) );
		assert( arrayLen( t ), "Conditionals inList" );
		t = ormservice.findAllByLastNameNotInList( listToArray( "Majano,Fernando" ) );
		assert( arrayLen( t ), "Conditionals NotinList" );
	}

	function testFindByDynamicallyBadProperty(){
		expectException( "InvalidMethodGrammar" );
		t = ormservice.findByLastAndFirst();
	}

	function testFindByDynamicallyFailure(){
		expectException( "HQLQueryException" );
		t = ormservice.findByLastName();
	}


	function testNew(){
		user = ormservice.new();
		assertFalse( isNull( user ) );

		user = ormService.new( properties = { firstName : "Luis", lastName : "UnitTest" } );
		assertEquals( "Luis", user.getFirstName() );
	}

	function testGet(){
		user = ormService.get( "123" );
		assertTrue( isNull( user ) );

		user = ormService.get( testUserID );
		assertEquals( testUserID, user.getID() );
	}

	function testGetAll(){
		r = ormService.getAll();
		assertTrue( arrayLen( r ) );

		r = ormService.getAll( [ 1, 2 ] );
		assertFalse( arrayLen( r ) );

		r = ormService.getAll( testUserID );
		assertTrue( isObject( r[ 1 ] ) );

		r = ormService.getAll( [ testUserID, testUserID ] );
		assertTrue( isObject( r[ 1 ] ) );
	}

	function testDeleteByID(){
		user = entityNew( "User" );
		user.setFirstName( "unitTest" );
		user.setLastName( "unitTest" );
		user.setUsername( "unitTest" );
		user.setPassword( "unitTest" );
		entitySave( user );
		ormFlush();

		try {
			if ( structKeyExists( server, "lucee" ) ) {
				ormCloseSession();
			}
			ormservice.deleteByID( user.getID() );
			test = entityLoad( "User", { firstName : "unittest" }, true );
			assertTrue( isNull( test ) );
		} catch ( any e ) {
			fail( e.detail & e.message );
		} finally {
			queryExecute( "delete from users where firstName = 'unitTest'" );
		}
	}

	function testDeleteWhere(){
		for ( var x = 1; x lte 3; x++ ) {
			user = entityNew( "User" );
			user.setFirstName( "unitTest#x#" );
			user.setLastName( "unitTest" );
			user.setUsername( "unitTest" );
			user.setPassword( "unitTest" );
			entitySave( user );
		}
		ormFlush();

		try {
			if ( structKeyExists( server, "lucee" ) ) {
				ormCloseSession();
			}
			ormService.deleteWhere( userName = "unitTest" );

			result = queryExecute( "select * from users where userName = 'unitTest'" );
			assertEquals( 0, result.recordcount );
		} catch ( any e ) {
			fail( e.detail & e.message & e.stackTrace );
		} finally {
			queryExecute( "delete from users where userName = 'unitTest'" );
		}
	}

	function testCount(){
		count = ormService.count();
		assertTrue( count gt 0 );

		count = ormService.count( "firstname='luis'" );
		assertEquals( 1, count );
	}

	function testList(){
		test = ormservice.list( sortorder = "lastName asc" );

		assertTrue( isArray( test ) );
		assertTrue( arrayLen( test ) );
	}

	function testFindWhere(){
		test = ormservice.findWhere( { firstName : "Luis" } );
		assertEquals( "Majano", test.getLastName() );
	}

	function testFindAllWhere(){
		test = ormservice.findAllWhere( { firstName : "Luis" } );
		assertEquals( 1, arrayLen( test ) );
	}


	function testGetKey(){
		test = ormservice.getKey( entityName = "User" );
		assertEquals( "id", test );
	}

	function testGetPropertyNames(){
		test = ormservice.getPropertyNames( entityName = "User" );
		assertEquals( 6, arrayLen( test ) );
	}

	function testGetTableName(){
		test = ormservice.getTableName();
		assertEquals( "users", test );
	}

	function testNewCriteria(){
		c = ormservice.newCriteria();
		assertEquals( "User", c.getEntityName() );
	}

	function testConvertIDValueToJavaType(){
		test = ormservice.convertIDValueToJavaType( id = 1 );
		assertEquals( [ 1 ], test );

		test = ormservice.convertIDValueToJavaType( id = [ "1", "2", "3" ] );
		assertEquals( [ 1, 2, 3 ], test );
	}

	function testConvertValueToJavaType(){
		test = ormservice.convertValueToJavaType( propertyName = "id", value = testUserID );
		assertEquals( testUserID, test );
	}

}

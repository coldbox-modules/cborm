component extends="tests.resources.BaseTest" {

	function beforeTests(){
		super.beforeTests();
		// Load our test injector for ORM entity binding
	}

	function teardown(){
		ormClearSession();
	}

	function setup(){
		super.setup();

		variables.ormservice = createMock( "cborm.models.BaseORMService" )

		if( isBoxLang() ){
			variables.mockEH     = createMock( "cborm.models.BXEventHandler" )
		} else {
			variables.mockEH     = createMock( "cborm.models.EventHandler" )
		}
		variables.mockEH.$( "announceInterception", true ).$( "announce", true )

		// Mocks
		variables.ormservice.init();

		// Mock event handler
		variables.ormservice.$property( "ORMEventHandler", "variables", variables.mockEH );

		// Test ID's
		variables.testUserID = "88B73A03-FEFA-935D-AD8036E1B7954B76";
		variables.testCatID  = "3A2C516C-41CE-41D3-A9224EA690ED1128";
		variables.test2      = [ "1", "2" ];

		variables.ormUtil = new cborm.models.util.ORMUtilFactory().getORMUtil();
	}

	function testCountByDynamically(){
		// Test simple Equals
		t = ormservice.countByLastName( "User", "majano" );
		assert( 1 eq t, "CountBylastName" );
	}

	function testFindAllByDynamically(){
		// Using Conditionals
		t = ormservice.findAllByLastNameLessThan( "User", "Majano" );
		assert( arrayLen( t ), "Conditionals LessThan" );

		t = ormservice.findAllByLastNameLessThanEquals( "User", "Majano", { sortBy : "LastName" } );
		assert( arrayLen( t ), "Conditionals LessThanEquals" );

		t = ormservice.findAllByLastNameGreaterThan( "User", "Majano" );
		assert( arrayLen( t ), "Conditionals GreaterThan" );

		t = ormservice.findAllByLastNameGreaterThanEquals( "User", "Majano" );
		assert( arrayLen( t ), "Conditionals GreaterThanEqauls" );

		t = ormservice.findAllByLastNameNotEqual( "User", "Majano" );
		assert( arrayLen( t ), "Conditionals Equal" );

		t = ormservice.findAllByLastNameIsNotNull( "User" );
		assert( arrayLen( t ), "Conditionals isNull" );

		t = ormservice.findAllByLastNameInList( "User", "Majano,Fernando" );
		assert( arrayLen( t ), "Conditionals inList" );

		t = ormservice.findAllByLastNameInList( "User", listToArray( "Majano,Fernando" ) );
		assert( arrayLen( t ), "Conditionals inList" );

		t = ormservice.findAllByLastNameNotInList( "User", listToArray( "Majano,Fernando" ) );
		assert( arrayLen( t ), "Conditionals NotinList" );
	}

	function testFindByDynamically(){
		t = ormservice.findByLastNameLike( "User", "ma%" );
		assert( isObject( t ), "Conditionals Like" );
		t = ormservice.findByLastNameIsNull( "User" );
		assert( isNull( t ), "Conditionals isNull" );
		// Test simple Equals
		t = ormservice.findByLastName( "User", "majano" );
		assert( isObject( t ), "FindBylastName" );
		// Test simple Equals with invalid
		t = ormservice.findByLastName( "User", "d" );
		assert( isNull( t ), "Invalid last name" );
		t = ormservice.findByLastLoginBetween( "User", "01/01/2008", "11/01/2008" );
		assert( isNull( t ), "Conditionals between" );
		t = ormservice.findByLastLoginNotBetween( "User", "2008-01-01", "2013-01-01" );
		assert( !isNull( t ), "Conditionals not between" );
	}

	function testFindByDynamicallyBadProperty(){
		expectException( "InvalidMethodGrammar" );
		t = ormservice.findByLastAndFirst( "User" );
	}

	function testFindByDynamicallyFailure(){
		expectException( "HQLQueryException" );
		t = ormservice.findByLastName( "User" );
	}

	function testExists(){
		assertEquals( false, ormservice.exists( "Category", "123" ) );
		assertEquals( true, ormservice.exists( "Category", testCatID ) );
	}

	function testClear(){
		test  = entityLoad( "User" );
		stats = ormservice.getSessionStatistics();
		// debug( stats );

		ormservice.clear();

		stats = ormservice.getSessionStatistics();
		assertEquals( 0, stats.entityCount );
	}

	function testGetSessionStatistics(){
		ormservice.clear();
		stats = ormservice.getSessionStatistics();
		assertEquals( 0, stats.entityCount );
		assertEquals( 0, stats.collectionCount );
		assertEquals( "[]", stats.entityKeys );
		assertEquals( "[]", stats.collectionKeys );
	}

	function testisSessionDirty(){
		ormService.clear();
		assertFalse( ormservice.isSessionDirty() );
		test = entityLoad( "User", { firstName : "Luis" }, true );
		test.setPassword( "unit_tests" );
		assertTrue( ormService.isSessionDirty() );
		ormClearSession();
	}

	function testSessionContains(){
		expect( ormservice.sessionContains( entityNew( "User" ) ) ).toBeFalse();
		var  test = entityLoad( "User", { firstName : "Luis" }, true );
		expect( ormservice.sessionContains( test ) ).toBeTrue();

		ormservice.evict( test );
		expect( ormservice.sessionContains( test ) ).toBeFalse();
	}

	function testEvictionByEntityObject(){
		ormClearSession();
		var test = entityLoad( "User", { firstName : "Luis" }, true );
		ormservice.evict( test );
		expect( ormservice.sessionContains( test ) ).toBeFalse();
	}

	function testEvictionByEntityObjects(){
		ormClearSession();
		var test = entityLoad( "User" );
		ormservice.evict( test );
		expect( ormservice.getSessionStatistics().entityCount ).toBe( 0 );
	}

	function testNew(){
		ormservice.new( "User" );

		// Test with arguments.
		user = ormService.new( entityName = "User", properties = { firstName : "luis", lastName : "majano" } );
		// debug( user );
		assertEquals( "luis", user.getFirstName() );
		assertEquals( "majano", user.getLastName() );
	}

	function testNewWithProperties(){
		// Test Porperties
		user = ormService.new( "User", { firstName : "pio", lastName : "majano" } );
		// debug( user );
		assertEquals( "pio", user.getFirstName() );
		assertEquals( "majano", user.getLastName() );
	}

	function testNewWithEvents(){
		ormService.setEventHandling( true );
		var eventHandler = prepareMock( ormService.getORMEventHandler() ).$( "postNew" );

		// Call it
		ormservice.new( "User" );

		assertTrue( arrayLen( eventHandler.$callLog().postNew ) );
	}

	function testGet(){
		user = ormService.get( "User", "123" );
		assertTrue( isNull( user ) );

		user = ormService.get( "User", testUserID );
		assertEquals( testUserID, user.getID() );

		user = ormService.get( "User", 0 );
		assertTrue( isNull( user.getID() ) );

		user = ormService.get( "User", "" );
		assertTrue( isNull( user.getID() ) );

		// ReturnNew = false
		user = ormService.get( entityName = "User", id = 4, returnNew = false );
		assertTrue( isNull( user ) );
		user = ormService.get( entityName = "User", id = 0, returnNew = false );
		assertTrue( isNull( user ) );
	}

	function testgetKeyValue(){
		var test = entityLoad(
			"category",
			"A13C0DB0-0CBC-4D85-A5261F2E3FCBEF91",
			true
		);
		var targetID = ormService.getKeyValue( test );
		expect( targetID ).toBe( "A13C0DB0-0CBC-4D85-A5261F2E3FCBEF91" );

		var targetID = ormService.getKeyValue( entityNew( "Category" ) );
		expect( isNull( targetID ) ).toBeTrue();
	}

	function testIsDirty(){
		var role = entityLoad( "Role", { role : "Administrator" }, true );
		expect( ormService.isDirty( role ) ).toBeFalse();

		expect( ormService.isDirty( entityNew( "Category" ) ) ).toBeFalse();

		var test = entityLoad(
			"category",
			"A13C0DB0-0CBC-4D85-A5261F2E3FCBEF91",
			true
		);
		test.setCategory( "dirty" );
		test.setDescription( "dirty dirty" );
		expect( ormService.isDirty( test ) ).toBeTrue();

		ormClearSession();

		var test = entityLoad(
			"category",
			"A13C0DB0-0CBC-4D85-A5261F2E3FCBEF91",
			true
		);
		expect( ormService.isDirty( test ) ).toBeFalse();
	}

	function testgetDirtyPropertyNames(){
		var test = entityLoad(
			"category",
			"A13C0DB0-0CBC-4D85-A5261F2E3FCBEF91",
			true
		);
		test.setCategory( "dirty" );
		test.setDescription( "dirty dirty" );

		var properties = ormService.getDirtyPropertyNames( test );
		// debug( properties );
		expect( properties ).toHaveLength( 2 );
	}

	function testGetAll(){
		var test = entityLoad(
			"category",
			"A13C0DB0-0CBC-4D85-A5261F2E3FCBEF91",
			true
		);

		r = ormService.getAll( entityName = "Category", properties = "catid as id,category as category" );
		assertTrue( arrayLen( r ) );

		r = ormService.getAll(
			"Category",
			"A13C0DB0-0CBC-4D85-A5261F2E3FCBEF91",
			"category asc"
		);
		assertTrue( arrayLen( r ) eq 1 );

		r = ormService.getAll( "Category", [ 1, 2 ] );
		assertFalse( arrayLen( r ) );

		r = ormService.getAll( "Category", testCatID );
		assertTrue( isObject( r[ 1 ] ) );

		r = ormService.getAll( "Category", [ testCatID, testCatID ] );
		assertTrue( isObject( r[ 1 ] ) );

		r = ormService.getAll( entityName = "Category", sortOrder = "category desc" );
		assertTrue( arrayLen( r ) );

		// readonly
		r = ormService.getAll( entityName = "Category", readOnly = true );
		assertTrue( arrayLen( r ) );
	}

	function testDelete(){
		// cleanup
		deleteCategories();

		var cat = entityNew( "Category" );
		cat.setCategory( "unitTest" );
		cat.setDescription( "unitTest" );
		entitySave( cat );
		ormFlush();

		try {
			var test = entityLoad( "Category", { category : "unittest" } );
			// debug( test );
			ormservice.delete( entity = test[ 1 ], transactional = false );
			ormFlush();
			ormservice.clear();

			var test = entityLoad( "Category", { category : "unittest" } );
			// debug(test);
			assertTrue( arrayLen( test ) eq 0 );
		} catch ( any e ) {
			rethrow;
		} finally {
			deleteCategories();
		}
	}

	function testDeleteWithFlush(){
		ormservice.clear();

		cat = entityNew( "Category" );
		cat.setCategory( "unitTest" );
		cat.setDescription( "unitTest" );
		entitySave( cat );
		ormFlush();

		try {
			test = entityLoad( "Category", { "category" : "unitTest" }, true );
			// debug(test);
			ormservice.delete(
				entity        = test,
				flush         = true,
				transactional = false
			);
			test = entityLoad( "Category", { category : "unitTest" }, true );
			assertTrue( isNull( test ) );
		} catch ( any e ) {
			rethrow;
		} finally {
			deleteCategories();
		}
	}

	function testDeleteByID(){
		var cat = entityNew( "Category" );
		cat.setCategory( "unitTest" );
		cat.setDescription( "unitTest" );

		entitySave( cat );
		ormFlush();

		try {
			ormCloseSession();
			ormClearSession();

			count = ormservice.deleteByID( "Category", cat.getCatID() );

			assertTrue( count gt 0 );
		} catch ( any e ) {
			rethrow;
		} finally {
			deleteCategories();
		}
	}

	function testDeleteByQuery(){
		for ( var x = 1; x lte 3; x++ ) {
			cat = entityNew( "Category" );
			cat.setCategory( "unitTest" );
			cat.setDescription( "unitTest at #now()#" );
			entitySave( cat );
		}
		ormFlush();

		try {
			var results = ormservice.deleteByQuery(
				query         = "from Category where category = :category",
				params        = { category : "unitTest" },
				transactional = false
			);
			debug( "Removed #results# records" );
			ormFlush();
			var result = queryExecute( "select * from categories where category = 'unitTest'" );
			assertEquals( 0, result.recordcount );
		} catch ( any e ) {
			rethrow;
		} finally {
			deleteCategories();
		}
	}

	function testDeleteWhere(){
		for ( var x = 1; x lte 3; x++ ) {
			cat = entityNew( "Category" );
			cat.setCategory( "unitTest" );
			cat.setDescription( "unitTest at #now()#" );
			entitySave( cat );
		}
		ormFlush();

		try {
			var count = ormService.deleteWhere(
				entityName    = "Category",
				category      = "unitTest",
				transactional = false
			);
			debug( "Delete where: #count#" );

			var result = queryExecute( "select * from categories where category = 'unitTest'" );
			assertEquals( 0, result.recordcount );
		} catch ( any e ) {
			rethrow;
		} finally {
			deleteCategories();
		}
	}

	function testSave(){
		// mocks
		// mocks
		if( isBoxLang() ) {
			mockEventHandler = createEmptyMock( "cborm.models.BXEventHandler" );
		} else {
			mockEventHandler = createEmptyMock( "cborm.models.EventHandler" );
		}
		mockEventHandler.$( "preSave" );
		mockEventHandler.$( "postSave" );
		ormService.$property(
			"ORMEventHandler",
			"variables",
			mockEventHandler
		);

		var cat = entityNew( "Category" );
		cat.setCategory( "unitTest" );
		cat.setDescription( "unitTest at #now()#" );

		try {
			var result = ormservice.save( entity = cat, transactional = false );
			assertTrue( len( cat.getCatID() ) );
			assertTrue( arrayLen( mockEventHandler.$callLog().preSave ) );
			assertTrue( arrayLen( mockEventHandler.$callLog().postSave ) );
		} catch ( any e ) {
			rethrow;
		} finally {
			deleteCategories();
		}
	}

	function testSaveNoTransaction(){
		// mocks
		if( isBoxLang() ) {
			mockEventHandler = createEmptyMock( "cborm.models.BXEventHandler" );
		} else {
			mockEventHandler = createEmptyMock( "cborm.models.EventHandler" );
		}
		mockEventHandler.$( "preSave" );
		mockEventHandler.$( "postSave" );
		ormService.$property(
			"ORMEventHandler",
			"variables",
			mockEventHandler
		);

		var cat = entityNew( "Category" );
		cat.setCategory( "unitTest" );
		cat.setDescription( "unitTest at #now()#" );

		try {
			ormservice.save( entity = cat, transactional = false );
			assertTrue( len( cat.getCatID() ) );
			assertTrue( arrayLen( mockEventHandler.$callLog().preSave ) );
			assertTrue( arrayLen( mockEventHandler.$callLog().postSave ) );
			var result = queryExecute( "select * from categories where category = 'unitTest'" );
			assertTrue( result.recordcount eq 0 );
		} catch ( any e ) {
			rethrow;
		}
	}

	function testSaveAll(){
		// mocks
		// mocks
		if( isBoxLang() ) {
			mockEventHandler = createEmptyMock( "cborm.models.BXEventHandler" );
		} else {
			mockEventHandler = createEmptyMock( "cborm.models.EventHandler" );
		}
		mockEventHandler.$( "preSave" ).$( "postSave" );
		ormService.$property(
			"ORMEventHandler",
			"variables",
			mockEventHandler
		);

		var cat = entityNew( "Category" );
		cat.setCategory( "unitTest" );
		cat.setDescription( "unitTest at #now()#" );

		var cat2 = entityNew( "Category" );
		cat2.setCategory( "unitTest" );
		cat2.setDescription( "unitTest at #now()#" );

		try {
			ormservice.saveAll( entities = [ cat, cat2 ], transactional = false );
			assertTrue( len( cat.getCatID() ) );
			assertTrue( len( cat2.getCatID() ) );
			assertTrue( arrayLen( mockEventHandler.$callLog().preSave ) );
			assertTrue( arrayLen( mockEventHandler.$callLog().postSave ) );
		} catch ( any e ) {
			rethrow;
		} finally {
			deleteCategories();
		}
	}

	function testSaveAllWithFlush(){
		// mocks
		// mocks
		if( isBoxLang() ) {
			mockEventHandler = createEmptyMock( "cborm.models.BXEventHandler" );
		} else {
			mockEventHandler = createEmptyMock( "cborm.models.EventHandler" );
		}
		mockEventHandler.$( "preSave" ).$( "postSave" );
		ormService.$property(
			"ORMEventHandler",
			"variables",
			mockEventHandler
		);

		var cat = entityNew( "Category" );
		cat.setCategory( "unitTest" );
		cat.setDescription( "unitTest at #now()#" );

		var cat2 = entityNew( "Category" );
		cat2.setCategory( "unitTest" );
		cat2.setDescription( "unitTest at #now()#" );

		try {
			ormservice.saveAll(
				entities      = [ cat, cat2 ],
				flush         = true,
				transactional = false
			);
			assertTrue( len( cat.getCatID() ) );
			assertTrue( len( cat2.getCatID() ) );
			assertTrue( arrayLen( mockEventHandler.$callLog().preSave ) );
			assertTrue( arrayLen( mockEventHandler.$callLog().postSave ) );
		} catch ( any e ) {
			rethrow;
		} finally {
			deleteCategories();
		}
	}

	function testRefresh(){
		var cat                 = entityLoad( "Category", { category : "Training" }, true );
		var id                  = cat.getCatID();
		var originalDescription = cat.getDescription();

		try {
			queryExecute( "update categories set description = 'unittest' where category_id = '#id#'" );

			ormservice.refresh( cat );

			assertEquals( "unittest", cat.getDescription() );
		} catch ( any e ) {
			rethrow;
		} finally {
			queryExecute(
				"update categories set description = '#originalDescription#' where category_id = '#id#'"
			);
		}
	}

	function testCount(){
		var count = ormService.count( "Category" );
		assertTrue( count gt 0 );

		var count = ormService.count( "Category", "category='general'" );
		assertEquals( 2, count );

		var count = ormService.count( "Category", "category=?", [ "Training" ] );
		assertEquals( 1, count );

		var count = ormService.count(
			"Category",
			"category=:category",
			{ category : "Training" }
		);
		assertEquals( 1, count );

		var count = ormService.count( "Category", "category like 'gen%'" );
		assertEquals( 2, count );

		var count = ormService.countWhere( entityName = "Category", category = "Training" );
		assertEquals( 1, count );

		var count = ormService.countWhere( entityName = "Category" );
		assertTrue( count > 1 );
	}

	function testList(){
		var criteria = { category : "general" };
		var test     = ormservice.list(
			entityName = "Category",
			sortorder  = "category asc",
			criteria   = criteria
		);
		assertTrue( arrayLen( test ) );

		// as array
		ormservice.setDefaultAsQuery( true );
		var test = ormservice.list(
			entityName = "Category",
			sortorder  = "category asc",
			criteria   = criteria
		);
		assertTrue( test.recordcount );
	}

	function testExecuteQuery(){
		var test = ormservice.executeQuery( query = "from Category" );
		// debug( test );
		assertTrue( isArray( test ) );
		assertTrue( arrayLen( test ) );

		var sql = "from Category where category = ?";

		if ( val( variables.ormUtil.getHibernateVersion() ) >= 5.3 ) {
			// hibernate 5.3+ JPA syntax
			sql = "from Category where category = ?1";
		}

		var params = [ "general" ];
		test       = ormservice.executeQuery( query = sql, params = params );
		assertTrue( arrayLen( test ) );
	}

	function testExecuteQueryWithUpdate(){
		var test = ormservice.executeQuery(
			query   = "UPDATE Category SET category = ? where category = 'LM' ",
			params  = [ "LM" ],
			asQuery = true
		);
		expect( test ).toBe( 1 );
	}

	function testFindIt(){
		var test = ormservice.findIt( "from Category where category = ?", [ "Training" ] );
		assertEquals( "Training", test.getCategory() );

		var test = ormservice.findIt( "from Category where category = :category", { category : "Training" } );
		assertEquals( "Training", test.getCategory() );
	}

	function testFindByExample(){
		var sample     = entityLoad( "Category", { category : "Training" }, true );
		var testSample = ormService.findByExample( sample, true );
		assertEquals( "Training", testSample.getCategory() );

		var sample = entityLoad( "Category", { category : "Training" }, true );
		var test   = ormService.findByExample( sample );
		assertEquals( "Training", test[ 1 ].getCategory() );
	}

	function testFindAll(){
		/**
		 * Test the Hibernate 5.2- syntax.
		 * "legacy-style" JDBC positional parameters are unsupported in 5.3+
		 */
		var sql = "from Category where category = ?";

		if ( val( variables.ormUtil.getHibernateVersion() ) >= 5.3 ) {
			// hibernate 5.3+ JPA syntax
			sql = "from Category where category = ?1";
		}

		var test = ormservice.findAll( sql, [ "Training" ] );
		assertEquals( 1, arrayLen( test ) );

		var test = ormservice.findAll( "from Category where category = :category", { category : "Training" } );
		assertEquals( 1, arrayLen( test ) );

		var test = ormService.findAll( query = "from Category", max = 2, offset = 1 );
		assertEquals( 2, arrayLen( test ) );
	}

	function testFindWhere(){
		var test = ormservice.findWhere( "Category", { category : "Training" } );
		assertEquals( "Training", test.getCategory() );

		var test = ormservice.findWhere( "User", { firstName : "Luis", lastName : "Majano" } );
		assertEquals( "Majano", test.getLastName() );
	}

	function testFindAllWhere(){
		var test = ormservice.findAllWhere( "Category", { category : "general" } );
		assertEquals( 2, arrayLen( test ) );

		var test = ormservice.findAllWhere(
			"Category",
			{ category : "general" },
			"category desc"
		);
		assertEquals( 2, arrayLen( test ) );

		var test = ormservice.findAllWhere( "User", { firstName : "Luis", lastName : "Majano" } );
		assertEquals( 1, arrayLen( test ) );
	}


	function testGetKey(){
		var test = ormservice.getKey( "Category" );
		assertEquals( "catid", test );

		var test = ormservice.getKey( "User" );
		assertEquals( "id", test );
	}

	function testGetPropertyNames(){
		var test = ormservice.getPropertyNames( "Category" );
		assertEquals( 4, arrayLen( test ) );

		var test = ormservice.getPropertyNames( "User" );
		assertEquals( 6, arrayLen( test ) );
	}

	function testGetTableName(){
		var test = ormservice.getTableName( "Category" );
		assertEquals( "categories", test );

		var test = ormservice.getTableName( "User" );
		assertEquals( "users", test );

		var test = ormservice.getTableName( entityNew( "User" ) );
		assertEquals( "users", test );
	}

	function testConvertIDValueToJavaType(){
		var test = ormservice.convertIDValueToJavaType( entityName = "User", id = 1 );
		assertEquals( [ 1 ], test );

		var test = ormservice.convertIDValueToJavaType( entityName = "User", id = [ "1", "2", "3" ] );
		assertEquals( [ 1, 2, 3 ], test );
	}

	function testConvertValueToJavaType(){
		var test = ormservice.convertValueToJavaType(
			entityName   = "User",
			propertyName = "id",
			value        = testUserID
		);
		assertEquals( testUserID, test );
	}

	function testCreateService(){
		UserService     = ormservice.CreateService( entityName = "User" );
		CategoryService = ormservice.CreateService( entityName = "Category" );

		var test = UserService.getKey();
		assertEquals( "id", test );

		var test = UserService.getTableName();
		assertEquals( "users", test );

		var test = CategoryService.getKey();
		assertEquals( "catid", test );

		var test = CategoryService.getTableName();
		assertEquals( "categories", test );
	}

	function testgetEntityGivenName(){
		// loaded entity
		var test = entityLoad( "User", { firstName : "Luis" }, true );
		var r    = ormservice.getEntityGivenName( test );
		// debug( r );
		assertEquals( "User", r );

		var r = ormservice.getEntityGivenName( entityNew( "User" ) );
		// debug( r );
		assertEquals( "User", r );
	}

	function testNewCriteria(){
		var c = ormservice.newCriteria( "User" );
		expect( c ).toBeComponent();
		expect( c.getEntityName() ).toBe( "User" );
	}

	function testMerge(){
		// loaded entity
		var test  = entityLoad( "User", { firstName : "Luis" }, true );
		var stats = ormservice.getSessionStatistics();

		ormClearSession();
		stats = ormservice.getSessionStatistics();
		assertEquals( 0, stats.entityCount );

		test  = ormservice.merge( test );
		stats = ormservice.getSessionStatistics();
		assertEquals( 1, stats.entityCount );
	}

	function testMergeArray(){
		var test = entityLoad( "User", { firstName : "Luis" }, true );

		ormClearSession();
		var stats = ormservice.getSessionStatistics();
		assertEquals( 0, stats.entityCount );

		var aTests = ormservice.merge( [ test ] );
		var stats  = ormservice.getSessionStatistics();
		assertEquals( 1, stats.entityCount );
		expect( aTests ).toBeArray();
	}

	function testGetRestrictions(){
		var r = ormservice.getRestrictions();
		expect( r ).toBeComponent();
	}

	function testGetOrFail(){
		expect( function(){
			ormService.getOrFail( "User", 10000 );
		} ).toThrow();
	}

	private function deleteCategories(){
		queryExecute( "delete from categories where category = 'unitTest'" );
	}

}

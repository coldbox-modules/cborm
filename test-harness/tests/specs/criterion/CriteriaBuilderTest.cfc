component extends="tests.resources.BaseTest" {

	function beforeTests(){
		super.beforeTests();
	}

	function setup(){
		super.setup();

		criteria = createMock( "cborm.models.criterion.CriteriaBuilder" );
		criteria.init( entityName = "User", ormService = new cborm.models.BaseORMService() );

		// Test ID's
		testUserID = "88B73A03-FEFA-935D-AD8036E1B7954B76";
		testCatID  = "3A2C516C-41CE-41D3-A9224EA690ED1128";
		test2      = [ "1", "2" ];
	}

	function testGet(){
		r = criteria.idEQ( testUserID ).get();
		assertEquals( testUserID, r.getID() );
	}

	function testGetWithProperties(){
		r = criteria.idEQ( testUserID ).get( properties = "id,firstName,lastName" );
		debug( r );
		expect( r ).toBeStruct().toHaveKey( "id,firstName,lastName" );
	}

	function testWhen(){
		var r = criteria
			.when( true, function( c ){
				c.idEQ( testUserID );
			} )
			.get();
		expect( r.getId(), testUserId );
	}

	function testWhenFalse(){
		var r = criteria
			.when( false, function( c ){
				throw( "exception" );
				c.idEQ( testUserID );
			} )
			.when( true, function( c ){
				c.idEQ( testUserID );
			} )
			.get();
		expect( r.getId(), testUserId );
	}

	function testGetOrFail(){
		expect( function(){
			criteria.idEQ( "32234234234234" ).getOrFail();
		} ).toThrow();
	}

	function testTimeout(){
		r = criteria.timeout( 10 );
	}

	function testReadOnly(){
		r = criteria.readOnly();
		r = criteria.readOnly( false );
	}

	function testMaxResults(){
		r = criteria.maxResults( 10 );
	}

	function testFirstResult(){
		r = criteria.firstResult( 10 );
	}

	function testFetchSize(){
		r = criteria.fetchSize( 10 );
	}

	function testCache(){
		r = criteria.cache();
		r = criteria.cache( false );
		r = criteria.cache( true, "pio" );
	}

	function testCacheRegion(){
		r = criteria.cacheRegion( "pio" );
	}

	function testCount(){
		criteria.init( entityName = "User", ormService = new cborm.models.BaseORMService() );
		r     = criteria.count();
		count = queryExecute( "select count(*) allCount from users" );
		assertEquals( count.allCount, r );

		r = criteria.count( "id" );
		assertEquals( count.allCount, r );
	}

	function testList(){
		r = criteria.list();
		assertTrue( arrayLen( r ) );

		r = criteria.list( max = 1 );
		assertEquals( 1, arrayLen( r ) );

		r = criteria.list( max = 1, offset = 2 );
		assertEquals( 1, arrayLen( r ) );

		r = criteria.list( timeout = 2 );
		assertEquals( 1, arrayLen( r ) );

		criteria.init( entityName = "User", ormService = new cborm.models.BaseORMService() );
		r = criteria.list( sortOrder = "lastName asc, firstName desc" );
		assertTrue( arrayLen( r ) );
	}

	function testListAsStreams(){
		criteria.init( entityName = "User", ormService = new cborm.models.BaseORMService() );
		r = criteria
			.asStream()
			.list( sortOrder = "lastName asc, firstName desc" )
			.filter( function( item ){
				return item.getFirstName().findNoCase( "ken" );
			} )
			.collect();

		expect( r ).toBeArray().toHaveLength( 1 );

		criteria.init( entityName = "User", ormService = new cborm.models.BaseORMService() );
		r = criteria
			.list( sortOrder = "lastName asc, firstName desc", asStream = true )
			.filter( function( item ){
				return item.getFirstName().findNoCase( "ken" );
			} )
			.collect();

		expect( r ).toBeArray().toHaveLength( 1 );
	}

	function testCreateSubcriteria(){
		s = createMock( "cborm.models.criterion.DetachedCriteriaBuilder" );
		assertTrue( isInstanceOf( s, "cborm.models.criterion.DetachedCriteriaBuilder" ) );
	}

	function testConvertIDValueToJavaType(){
		test = criteria.convertIDValueToJavaType( id = 1 );
		assertEquals( [ 1 ], test );

		test = criteria.convertIDValueToJavaType( id = [ "1", "2", "3" ] );
		assertEquals( [ 1, 2, 3 ], test );
	}

	function testConvertValueToJavaType(){
		test = criteria.convertValueToJavaType( propertyName = "id", value = testUserID );
		assertEquals( testUserID, test );
	}

}

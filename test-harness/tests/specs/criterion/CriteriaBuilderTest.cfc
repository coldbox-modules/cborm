/**
 * cborm 6 criteria: newCriteria() is a bx-orm entityCriteria(). These specs cover the cborm-style calls apps make on it.
 */
component extends="tests.resources.BaseTest" {

	function beforeTests(){
		super.beforeTests();
	}

	function setup(){
		super.setup();

		variables.ormService = new cborm.models.BaseORMService();
		variables.criteria   = variables.ormService.newCriteria( "User" );

		// Test ID's
		variables.testUserID = "88B73A03-FEFA-935D-AD8036E1B7954B76";
		variables.testCatID  = "3A2C516C-41CE-41D3-A9224EA690ED1128";
	}

	function testGet(){
		var r = criteria.idEq( testUserID ).get();
		assertEquals( testUserID, r.getID() );
	}

	function testGetProjectedStruct(){
		// cborm 5 get( properties ) is withProjections() + asStruct() in cborm 6
		var r = criteria
			.idEq( testUserID )
			.withProjections( property = "id,firstName,lastName" )
			.asStruct()
			.get();
		expect( r ).toBeStruct().toHaveKey( "id" ).toHaveKey( "firstName" ).toHaveKey( "lastName" );
	}

	function testWhen(){
		var r = criteria
			.when( true, function( c ){
				c.idEq( testUserID );
			} )
			.get();
		expect( r.getId() ).toBe( testUserID );
	}

	function testWhenFalse(){
		var r = criteria
			.when( false, function( c ){
				throw( "exception" );
			} )
			.when( true, function( c ){
				c.idEq( testUserID );
			} )
			.get();
		expect( r.getId() ).toBe( testUserID );
	}

	function testGetOrFail(){
		expect( function(){
			criteria.idEq( "32234234234234" ).getOrFail();
		} ).toThrow();
	}

	function testOptions(){
		var r = criteria
			.timeout( 10 )
			.readOnly()
			.readOnly( false )
			.maxResults( 10 )
			.firstResult( 0 )
			.fetchSize( 10 )
			.cache()
			.cache( false )
			.cache( true, "pio" )
			.list();
		expect( r ).toBeArray().notToBeEmpty();
	}

	function testCount(){
		var count = queryExecute( "select count(*) allCount from users" );
		expect( criteria.count() ).toBe( count.allCount );
		expect( ormService.newCriteria( "User" ).count( "id" ) ).toBe( count.allCount );
	}

	function testList(){
		expect( criteria.list() ).notToBeEmpty();
		expect( criteria.list( max = 1 ) ).toHaveLength( 1 );
		expect( criteria.list( max = 1, offset = 2 ) ).toHaveLength( 1 );
		expect( criteria.list( sortOrder = "lastName asc, firstName desc" ) ).notToBeEmpty();
	}

	function testRestrictions(){
		var r = criteria.restrictions;
		expect(
			ormService
				.newCriteria( "User" )
				.or( r.isEq( "firstName", "Luis" ), r.isEq( "firstName", "nobody" ) )
				.count()
		).toBe( 1 );
		expect(
			ormService
				.newCriteria( "User" )
				.add( r.isEq( "firstName", "Luis" ) )
				.count()
		).toBe( 1 );
	}

	function testSqlLog(){
		var c = ormService
			.newCriteria( "User" )
			.startSqlLog()
			.isEq( "firstName", "Luis" )
			.logSQL( "users" );

		expect( c.canLogSql() ).toBeTrue();
		expect( c.getSqlLog() ).toHaveLength( 1 );
		expect( c.getSqlLog()[ 1 ].type ).toBe( "users" );
		expect( c.getSqlLog()[ 1 ].sql ).toInclude( "users" );

		c.stopSqlLog();
		expect( c.canLogSql() ).toBeFalse();
	}

	function testCriteriaEventsReachColdBoxInterceptors(){
		request.cbormCriteriaEvents = [];
		getController()
			.getInterceptorService()
			.listen( function( event, data ){
				request.cbormCriteriaEvents.append( data.type );
			}, "onCriteriaBuilderAddition" );

		ormService.newCriteria( "User" ).isEq( "firstName", "Luis" );

		expect( request.cbormCriteriaEvents ).toInclude( "isEq" );
	}

	function testIdCastIsANoOp(){
		expect( ormService.idCast( "User", "1,2" ) ).toBe( [ "1", "2" ] );
		expect( ormService.autoCast( "User", "id", testUserID ) ).toBe( testUserID );
	}

}

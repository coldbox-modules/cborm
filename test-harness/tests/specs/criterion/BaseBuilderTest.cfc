component extends="tests.resources.BaseTest" {

	function beforeTests(){
		super.beforeTests();
		// Load our test injector for ORM entity binding
	}

	function setup(){
		super.setup();

		ormService       = createMock( "cborm.models.BaseORMService" ).init();
		mockEventHandler = createMock( "cborm.models.EventHandler" ).$(
			"getEventManager",
			createStub().$( "processState" )
		);
		ormService.setORMEventHandler( mockEventHandler );
		ormservice.seteventHandling( false );

		criteria    = new cborm.models.criterion.CriteriaBuilder( entityName = "User", ORMService = ormService );
		subCriteria = createMock( "cborm.models.criterion.DetachedCriteriaBuilder" );
		subCriteria.init(
			entityName = "User",
			alias      = "User2",
			ormService = ormService
		);

		// Test ID's
		testUserID = "88B73A03-FEFA-935D-AD8036E1B7954B76";
		testCatID  = "3A2C516C-41CE-41D3-A9224EA690ED1128";
		test2      = [ "1", "2" ];
	}

	function testCreateCriteria(){
		// with join Type
		r = new cborm.models.criterion.CriteriaBuilder( entityName = "Role", ormService = ormService )
			.withusers( criteria.LEFT_JOIN )
			.like( "lastName", "M%" )
			.peek( function( criteria ){
				debug( "running in a peek" );
			} )
			.list();

		assertEquals( "Administrator", r[ 1 ].getRole() );

		var r = new cborm.models.criterion.CriteriaBuilder( entityName = "Role", ormService = ormService )
			.createCriteria( associationName = "users", joinType = criteria.INNER_JOIN )
			.like( "lastName", "M%" )
			.list();

		assertEquals( "Administrator", r[ 1 ].getRole() );


		// No Joins
		r = new cborm.models.criterion.CriteriaBuilder( entityName = "Role", ormService = ormService )
			.withusers()
			.like( "lastName", "M%" )
			.list();
		assertEquals( "Administrator", r[ 1 ].getRole() );
		// with alias
		r = new cborm.models.criterion.CriteriaBuilder( entityName = "Role", ormService = ormService )
			.createCriteria( associationName = "users", alias = "user" )
			.like( "user.lastName", "M%" )
			.list();
		assertEquals( "Administrator", r[ 1 ].getRole() );
		// with alias & join type
		r = new cborm.models.criterion.CriteriaBuilder( entityName = "Role", ormService = ormService )
			.createCriteria(
				associationName = "users",
				alias           = "user",
				joinType        = criteria.LEFT_JOIN
			)
			.like( "user.lastName", "M%" )
			.list();
		assertEquals( "Administrator", r[ 1 ].getRole() );
		// with alias & join type & withClause
		r = new cborm.models.criterion.CriteriaBuilder( entityName = "Role", ormService = ormService )
			.createCriteria(
				associationName = "users",
				alias           = "user",
				joinType        = criteria.LEFT_JOIN,
				withClause      = criteria.restrictions.like( "user.lastName", "M%" )
			)
			.list();
		assertEquals( "Administrator", r[ 1 ].getRole() );
	}

	function testCreateAlias(){
		// with alias and join type
		r = new cborm.models.criterion.CriteriaBuilder( entityName = "Role", ormService = ormService )
			.createAlias( "users", "u", criteria.INNER_JOIN )
			.like( "u.lastName", "M%" )
			.list();
		assertEquals( "Administrator", r[ 1 ].getRole() );
		// with alias,join type and withClause
		r = new cborm.models.criterion.CriteriaBuilder( entityName = "Role", ormService = ormService )
			.createAlias(
				"users",
				"u",
				criteria.LEFT_JOIN,
				criteria.restrictions.like( "u.lastName", "M%" )
			)
			.list();
		assertEquals( "Administrator", r[ 1 ].getRole() );

		// no join type
		r = new cborm.models.criterion.CriteriaBuilder( entityName = "Role", ormService = ormService )
			.createAlias( "users", "u" )
			.like( "u.lastName", "M%" )
			.list();
		assertEquals( "Administrator", r[ 1 ].getRole() );
		// no join type, but withClause
		r = new cborm.models.criterion.CriteriaBuilder( entityName = "Role", ormService = ormService )
			.createAlias(
				associationName = "users",
				alias           = "u",
				withClause      = criteria.restrictions.like( "u.lastName", "M%" )
			)
			.list();
		assertEquals( "Administrator", r[ 1 ].getRole() );
	}

	function testResultTransformer(){
		r = criteria.resultTransformer( criteria.DISTINCT_ROOT_ENTITY ).list();
	}

	function testsetProjection(){
		r = criteria.setProjection( criteria.projections.rowCount() ).get();

		assertTrue( r gt 0 );
	}

	function testWithProjections(){
		r = criteria
			.withProjections(
				avg      = "lastLogin",
				rowCount = true,
				max      = "lastLogin"
			)
			.peek( function( c ){
				debug( c.getSql( true, true ) );
			} )
			.list();

		assertTrue( isArray( r ) );

		r = criteria
			.withProjections( property = "firstName,lastName" )
			.peek( function( c ){
				debug( c.getSql( true, true ) );
			} )
			.list();

		assertTrue( isArray( r ) );

		r = criteria
			.withProjections(
				detachedSQLProjection = [
					criteria.createSubcriteria( "Role", "Role1" ).withProjections( count = "Role1.role:Role" )
				]
			)
			.peek( function( c ){
				debug( c.getSql( true, true ) );
			} )
			.list();
		assertTrue( isArray( r ) );

		var categoryCriteria = new cborm.models.criterion.CriteriaBuilder(
			entityName = "Category",
			ORMService = ormService
		);

		r = categoryCriteria
			.withProjections(
				groupProperty = "catid",
				sqlProjection = [
					{
						sql      : "count( category_id )",
						alias    : "count",
						property : "catid"
					}
				],
				sqlGroupProjection = [
					{
						sql      : "year( modifydate )",
						group    : "year( modifydate )",
						alias    : "modifiedDate",
						property : "id"
					},
					{
						sql      : "dateDiff('2021-12-31 23:59:59','2021-12-30')",
						group    : "dateDiff('2021-12-31 23:59:59','2021-12-30')",
						alias    : "someDateDiff",
						property : "id"
					}
				]
			)
			.asStruct()
			.peek( function( c ){
				debug( c.getSql( true, true ) );
			} )
			.list();

		debug( r );
		assertTrue( isArray( r ) );
	}

	function testOrder(){
		r = criteria.order( "id" );
		r = criteria.order( "id", "desc" );
		r = criteria.order( "id", "desc", true );

		s = subCriteria.order( "id" );
		s = subCriteria.order( "id", "desc" );
		s = subCriteria.order( "id", "desc", true );
	}

	function testBetween(){
		r = criteria.between( "balance", 500, 1000 );
		s = subCriteria.between( "balance", 500, 1000 );
	}

	function testEQ(){
		r = criteria.eq( "balance", 500 );
		r = criteria.isEq( "balance", 500 );

		s = subCriteria.eq( "balance", 500 );
		s = subCriteria.isEq( "balance", 500 );
	}

	function testEqProperty(){
		r = criteria.eqProperty( "balance", "balance2" );
		s = subCriteria.eqProperty( "balance", "balance2" );
	}

	function testGT(){
		r = criteria.gt( "balance", 500 );
		r = criteria.isGT( "balance", 500 );

		s = subCriteria.gt( "balance", 500 );
		s = subCriteria.isGT( "balance", 500 );
	}

	function testgtProperty(){
		r = criteria.gtProperty( "balance", "balance2" );
		s = subCriteria.gtProperty( "balance", "balance2" );
	}

	function testGE(){
		r = criteria.ge( "balance", 500 );
		r = criteria.isGe( "balance", 500 );

		s = subCriteria.ge( "balance", 500 );
		s = subCriteria.isGe( "balance", 500 );
	}

	function testgeProperty(){
		r = criteria.geProperty( "balance", "balance2" );
		s = subCriteria.geProperty( "balance", "balance2" );
	}

	function testIDEq(){
		r = criteria.idEq( 45 );
		s = subCriteria.idEq( 45 );
	}

	function testilike(){
		r = criteria.ilike( "firstname", "lu%" );
		s = subCriteria.ilike( "firstname", "lu%" );
	}

	function testin(){
		r = criteria.in( "id", [ 1, 2, 3 ] );
		r = criteria.in( "id", "1,2,3" );
		r = criteria.isIn( "id", "1,2,3" );

		s = subCriteria.in( "id", [ 1, 2, 3 ] );
		s = subCriteria.in( "id", "1,2,3" );
		s = subCriteria.isIn( "id", "1,2,3" );
	}

	function testisEmpty(){
		r = criteria.isEmpty( "comments" );
		s = subCriteria.isEmpty( "comments" );
	}
	function testisNotEmpty(){
		r = criteria.isNotEmpty( "comments" );
		s = subCriteria.isNotEmpty( "comments" );
	}

	function testIsNull(){
		r = criteria.isNull( "lastName" );
		s = subCriteria.isNull( "lastName" );
	}
	function testIsNotNull(){
		r = criteria.isNotNull( "lastName" );
		s = subCriteria.isNotNull( "lastName" );
	}

	function testlT(){
		r = criteria.lt( "balance", 500 );
		r = criteria.islt( "balance", 500 );

		s = subCriteria.lt( "balance", 500 );
		s = subCriteria.islt( "balance", 500 );
	}

	function testltProperty(){
		r = criteria.ltProperty( "balance", "balance2" );
		s = subCriteria.ltProperty( "balance", "balance2" );
	}

	function testle(){
		r = criteria.le( "balance", 500 );
		r = criteria.isle( "balance", 500 );

		s = subCriteria.le( "balance", 500 );
		s = subCriteria.isle( "balance", 500 );
	}

	function testleProperty(){
		r = criteria.leProperty( "balance", "balance2" );
		s = subCriteria.leProperty( "balance", "balance2" );
	}

	function testlike(){
		r = criteria.like( "balance", "lui%" );
		s = subCriteria.like( "balance", "lui%" );
	}

	function testne(){
		r = criteria.ne( "balance", 500 );
		s = subCriteria.ne( "balance", 500 );
	}

	function testneProperty(){
		r = criteria.neProperty( "balance", "balance2" );
		s = subCriteria.neProperty( "balance", "balance2" );
	}

	function testsizeEq(){
		r = criteria.sizeEQ( "comments", 500 );
		s = subCriteria.sizeEQ( "comments", 500 );
	}

	function testsizeGT(){
		r = criteria.sizeGT( "comments", 500 );
		s = subCriteria.sizeGT( "comments", 500 );
	}
	function testsizeGE(){
		r = criteria.sizeGE( "comments", 500 );
		s = subCriteria.sizeGE( "comments", 500 );
	}
	function testsizeLT(){
		r = criteria.sizeLT( "comments", 500 );
		s = subCriteria.sizeLT( "comments", 500 );
	}
	function testsizeLE(){
		r = criteria.sizeLE( "comments", 500 );
		s = subCriteria.sizeLE( "comments", 500 );
	}
	function testsizeNE(){
		r = criteria.sizeNE( "comments", 500 );
		s = subCriteria.sizeNE( "comments", 500 );
	}

	function testConjunction(){
		r = criteria.conjunction( [
			criteria.restrictions.between( "balance", 100, 200 ),
			criteria.restrictions.lt( "salary", 20000 )
		] );
		s = subCriteria.conjunction( [
			subCriteria.restrictions.between( "balance", 100, 200 ),
			subCriteria.restrictions.lt( "salary", 20000 )
		] );
	}

	function testDisjunction(){
		r = criteria.disjunction( [
			criteria.restrictions.between( "balance", 100, 200 ),
			criteria.restrictions.lt( "salary", 20000 )
		] );
		s = subCriteria.disjunction( [
			subCriteria.restrictions.between( "balance", 100, 200 ),
			subCriteria.restrictions.lt( "salary", 20000 )
		] );
	}

	function testAnd(){
		r = criteria.and(
			criteria.restrictions.between( "balance", 100, 200 ),
			criteria.restrictions.isLt( "salary", 20000 )
		);
		s = subCriteria.$and(
			subCriteria.restrictions.between( "balance", 100, 200 ),
			subCriteria.restrictions.isLt( "salary", 20000 )
		);
	}

	function testOr(){
		r = criteria.or(
			criteria.restrictions.between( "balance", 100, 200 ),
			criteria.restrictions.lt( "salary", 20000 )
		);
		s = subCriteria.or(
			subCriteria.restrictions.between( "balance", 100, 200 ),
			subCriteria.restrictions.lt( "salary", 20000 )
		);
	}

	function testNot(){
		r = criteria.not( criteria.restrictions.gt( "salary", 200 ) );
		s = subCriteria.not( subCriteria.restrictions.gt( "salary", 200 ) );
	}

	function testAdd(){
		r = criteria.add( criteria.restrictions.gt( "salary", 200 ) );
		s = subCriteria.add( subCriteria.restrictions.gt( "salary", 200 ) );
	}

	function testGetSQL(){
		r = criteria
			.init( entityName = "Role", ormService = ormService )
			.createAlias( "users", "u", criteria.INNER_JOIN )
			.like( "u.lastName", "M%" );
		// test it returns a string
		assertTrue( isSimpleValue( r.getSQL() ) );
		// test it returns non-executable sql
		assertTrue( findNoCase( "?", r.getSQL( returnExecutableSql = false ) ) );
		// test it returns executable sql
		assertFalse( findNoCase( "?", r.getSQL( returnExecutableSql = true ) ) );
		// test it returns non-formatted sql
		assertFalse( findNoCase( "<pre>", r.getSQL( formatSql = false ) ) );
		// test it returns formatted sql
		assertTrue( findNoCase( "<pre>", r.getSQL( formatSql = true ) ) );
	}

	function testGetSqlLog(){
		r = criteria
			.init( entityName = "Role", ormService = ormService )
			.createAlias( "users", "u", criteria.INNER_JOIN )
			.like( "u.lastName", "M%" );

		assertIsArray( r.getSqlLog() );
	}

	function testStartSqlLog(){
		r = criteria
			.init( entityName = "Role", ormService = ormService )
			.createAlias( "users", "u", criteria.INNER_JOIN )
			.startSqlLog()
			.like( "u.lastName", "M%" );

		assertTrue( r.getSQLLoggerActive() );
	}

	function testStopSqlLog(){
		r = criteria
			.init( entityName = "Role", ormService = ormService )
			.startSqlLog()
			.createAlias( "users", "u", criteria.INNER_JOIN )
			.like( "u.lastName", "M%" )
			.stopSqlLog();

		assertFalse( r.getSQLLoggerActive() );
	}

	function testLogSql(){
		r = criteria
			.init( entityName = "Role", ormService = ormService )
			.createAlias( "users", "u", criteria.INNER_JOIN )
			.like( "u.lastName", "M%" );

		r.logSql( "FullQuery" );

		assertIsArray( r.getSqlLog() );
		assertTrue( arrayLen( r.getSqlLog() ) == 1 );
		assertTrue( r.getSqlLog()[ 1 ].Type == "FullQuery" );
	}

	function testCanLogSql(){
		r = criteria
			.init( entityName = "Role", ormService = ormService )
			.createAlias( "users", "u", criteria.INNER_JOIN )
			.like( "u.lastName", "M%" );
		// make the private method public
		makePublic( r, "canLogSql" );
		// start sql log=can log sql
		r.startSqlLog();
		assertTrue( r.getSQLLoggerActive() );
		// stop sql log=can't log sql
		r.stopSqlLog();
		assertFalse( r.getSQLLoggerActive() );
	}

	function testHasProjection(){
		r = criteria
			.init( entityName = "Role", ormService = ormService )
			.createAlias( "users", "u", criteria.INNER_JOIN )
			.like( "u.lastName", "M%" );
		// make the private method public
		makePublic( r, "hasProjection" );
		// no projection
		assertFalse( r.hasProjection() );
		// add projection
		r.withProjections( count = "u.lastName:LastName" );
		// with projection
		assertTrue( r.hasProjection() );
	}

	function testGetPositionalSQLParameterValues(){
		r = criteria
			.init( entityName = "Role", ormService = ormService )
			.createAlias( "users", "u", criteria.INNER_JOIN )
			.like( "u.lastName", "M%" );
		var values = r.getPositionalSQLParameterValues();
		// test it returns an array
		assertIsArray( values );
		// test it returns the number of param values we expect (1)
		assertTrue( arrayLen( values ) == 1 );
	}

	function testGetPositionalSQLParameterTypes(){
		r = criteria
			.init( entityName = "Role", ormService = ormService )
			.createAlias( "users", "u", criteria.INNER_JOIN )
			.like( "u.lastName", "M%" );
		var simpletypes   = r.getPositionalSQLParameterTypes( true );
		var complexttypes = r.getPositionalSQLParameterTypes( false );
		// test it returns an array
		assertIsArray( simpletypes );
		// test it returns the number of param types we expect (1)
		assertTrue( arrayLen( simpletypes ) == 1 );
		// if not simple, test that the result is an object
		assertTrue( isObject( complexttypes[ 1 ] ) );
	}

	function testGetPositionalSQLParameters(){
		r = criteria
			.init( entityName = "Role", ormService = ormService )
			.createAlias( "users", "u", criteria.INNER_JOIN )
			.like( "u.lastName", "M%" );
		var params = r.getPositionalSQLParameters();
		// test it returns an array
		assertIsArray( params );
		// test it returns the number of param types we expect (1)
		assertTrue( arrayLen( params ) == 1 );
	}

}

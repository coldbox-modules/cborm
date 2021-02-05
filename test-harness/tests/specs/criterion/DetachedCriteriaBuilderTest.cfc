component extends="tests.resources.BaseTest" {

	function beforeTests(){
		super.beforeTests();
		// Load our test injector for ORM entity binding
	}
	function setup(){
		ormService   = getMockBox().createMock( "cborm.models.BaseORMService" ).init();
		rootcriteria = getMockBox().createMock( "cborm.models.criterion.CriteriaBuilder" );
		rootcriteria.init(
			entityName = "User",
			ORMService = ormService
		);
		criteria         = getMockBox().createMock( "cborm.models.criterion.DetachedCriteriaBuilder" );
		mockEventManager = getMockBox().createStub();
		mockEventHandler = getMockBox().createStub().$( "getEventManager", mockEventManager );
		mockService      = getMockBox()
			.createEmptyMock( "cborm.models.BaseORMService" )
			.$(
				"getORMEventHandler",
				mockEventHandler
			);
		criteria.init( "Role", "Role", ormService );
		orm = new cborm.models.util.ORMUtilFactory().getORMUtil();
	}

	function testCreateDetachedSQLProjection(){
		criteria.withProjections( count = "Role.role" );
		var r = criteria.createDetachedSQLProjection();
		expect( getMetadata( r ).name ).toInclude( "org.hibernate.criterion" );
	}

	function testGetNativeCriteria(){
		criteria.withProjections( count = "Role.role" );
		expect(
			criteria
				.getNativeCriteria()
				.getClass()
				.getName()
		).toInclude( "CriteriaImpl" );
	}

	function testCreateAlias(){
		// just association and alias
		r = rootcriteria
			.init(
				entityName = "Role",
				ormService = ormService
			)
			.add(
				rootcriteria
					.createSubcriteria( "Role", "role" )
					.withProjections( property = "roleID" )
					.createAlias( "users", "user" )
					.like( "user.lastName", "M%" )
					.propertyIn( "roleID" )
			)
			.list();
		assertEquals( "Administrator", r[ 1 ].getRole() );

		// association and alias and jointype
		r = rootcriteria
			.init(
				entityName = "Role",
				ormService = ormService
			)
			.add(
				rootcriteria
					.createSubcriteria( "Role", "role" )
					.withProjections( property = "roleID" )
					.createAlias(
						"users",
						"user",
						rootcriteria.LEFT_JOIN
					)
					.like( "user.lastName", "M%" )
					.propertyIn( "roleID" )
			)
			.list();
		assertEquals( "Administrator", r[ 1 ].getRole() );
	}

	function testCreateCriteria(){
		// just association
		r = rootcriteria
			.init(
				entityName = "Role",
				ormService = ormService
			)
			.add(
				rootcriteria
					.createSubcriteria( "Role", "role" )
					.withProjections( property = "roleID" )
					.createCriteria( "users" )
					.like( "lastName", "M%" )
					.propertyIn( "roleID" )
			)
			.list();
		assertEquals( "Administrator", r[ 1 ].getRole() );
		// association and join type
		r = rootcriteria
			.init(
				entityName = "Role",
				ormService = ormService
			)
			.add(
				rootcriteria
					.createSubcriteria( "Role", "role" )
					.withProjections( property = "roleID" )
					.createCriteria(
						associationName = "users",
						joinType        = rootcriteria.LEFT_JOIN
					)
					.like( "lastName", "M%" )
					.propertyIn( "roleID" )
			)
			.list();
		assertEquals( "Administrator", r[ 1 ].getRole() );
		// association and join type and alias
		r = rootcriteria
			.init(
				entityName = "Role",
				ormService = ormService
			)
			.add(
				rootcriteria
					.createSubcriteria( "Role", "role" )
					.withProjections( property = "roleID" )
					.createCriteria(
						associationName = "users",
						alias           = "user",
						joinType        = rootcriteria.LEFT_JOIN
					)
					.like( "user.lastName", "M%" )
					.propertyIn( "roleID" )
			)
			.list();
		assertEquals( "Administrator", r[ 1 ].getRole() );
	}

	// test missingmethod handler functions
	function testSubEq(){
		criteria.withProjection( property = "fkentry_id" );
		s = criteria.subEq(
			"88B82629-B264-B33E-D1A144F97641614E",
			criteria
		);
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubEqAll(){
		s = criteria.subEqAll( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubGe(){
		s = criteria.subGe( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubGeAll(){
		s = criteria.subGeAll( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubGeSome(){
		s = criteria.subGeSome( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubGt(){
		s = criteria.subGt( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubGtAll(){
		s = criteria.subGtAll( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubGtSome(){
		s = criteria.subGtSome( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubIn(){
		s = criteria.subIn( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubLe(){
		s = criteria.subLe( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubLeAll(){
		s = criteria.subLeAll( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubLeSome(){
		s = criteria.subLeSome( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubLt(){
		s = criteria.subLt( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubLtAll(){
		s = criteria.subLtAll( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubLtSome(){
		s = criteria.subLtSome( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubNe(){
		s = criteria.subNe( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testSubNotIn(){
		s = criteria.subNotIn( 500 );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.SimpleSubqueryExpression"
			)
		);
	}
	function testExists(){
		s = criteria.exists();
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.ExistsSubqueryExpression"
			)
		);
	}
	function testNotExists(){
		s = criteria.notExists();
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.ExistsSubqueryExpression"
			)
		);
	}
	function testPropertyEq(){
		s = criteria.propertyEq( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyEqAll(){
		s = criteria.propertyEqAll( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyGe(){
		s = criteria.propertyGe( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyGeAll(){
		s = criteria.propertyGeAll( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyGeSome(){
		s = criteria.propertyGeSome( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyGt(){
		s = criteria.propertyGt( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyGtAll(){
		s = criteria.propertyGtAll( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyGtSome(){
		s = criteria.propertyGtSome( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyIn(){
		s = criteria.propertyIn( "entry_id" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyLe(){
		s = criteria.propertyLe( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyLeAll(){
		s = criteria.propertyLeAll( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyLeSome(){
		s = criteria.propertyLeSome( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyLt(){
		s = criteria.propertyLt( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyLtAll(){
		s = criteria.propertyLtAll( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyLtSome(){
		s = criteria.propertyLtSome( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyNe(){
		s = criteria.propertyNe( "views" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}
	function testPropertyNotIn(){
		s = criteria.propertyNotIn( "entry_id" );
		assertTrue(
			isInstanceOf(
				s,
				"org.hibernate.criterion.PropertySubqueryExpression"
			)
		);
	}

}

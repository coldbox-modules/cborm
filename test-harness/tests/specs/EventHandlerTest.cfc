component extends="tests.resources.BaseTest" {

	function beforeTests(){
		super.beforeTests();
		// Load our test injector for ORM entity binding
	}

	function setup(){
		variables.testUserID = "88B73A03-FEFA-935D-AD8036E1B7954B76";
	}

	function testInjection(){
		var user = entityLoad( "ActiveUser", testUserID, true );
		// debug( user );
		assertTrue( isObject( user.getWireBox() ) );
	}

	function testPostNewIsAnnouncedOnceByTheService(){
		request.cbormPostNewEvents = [];
		getController()
			.getInterceptorService()
			.listen( function( event, data ){
				request.cbormPostNewEvents.append( data.entityName );
			}, "ORMPostNew" );

		var service = new cborm.models.BaseORMService();
		service.setEventHandling( true );
		var user = service.new( entityName = "User", properties = { firstName : "unit", lastName : "test" } );

		// bx-orm's own postNew (from entityNew()) is skipped while the service builds the entity
		expect( request.cbormPostNewEvents ).toBe( [ "User" ] );
		expect( user.getFirstName() ).toBe( "unit" );
	}

	function testPostCommitIsAnnounced(){
		request.cbormPostCommitEvents = [];
		getController()
			.getInterceptorService()
			.listen( function( event, data ){
				request.cbormPostCommitEvents.append( data.entityName & ":" & data.action );
			}, "ORMPostCommit" );

		try {
			transaction {
				var cat = entityNew( "Category" );
				cat.setCategory( "unitTest" );
				cat.setDescription( "postCommit" );
				entitySave( cat );
			}
			expect( request.cbormPostCommitEvents ).toInclude( "Category:insert" );
		} finally {
			queryExecute( "delete from categories where category = 'unitTest'" );
		}
	}

}

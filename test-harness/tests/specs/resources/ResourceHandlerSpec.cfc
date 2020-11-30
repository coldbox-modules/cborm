component extends="tests.resources.BaseTest"{

	function run() {
		describe( "ORM Resource Handler", function() {
			aroundEach( function( spec, suite, data ) {
				// Setup as a new ColdBox request, VERY IMPORTANT. ELSE EVERYTHING LOOKS LIKE THE SAME REQUEST.
				setup();
				transaction action="begin" {
					try {
						arguments.spec.body( arguments.data );
					} catch ( any e ) {
						rethrow;
					} finally {
						transaction action="rollback";
						ormClearSession();
					}
				}
			} );

			story( "I want to list all resources", function() {
				given( "no options", function() {
					then( "it can display all resources", function() {
						var event    = this.get( "/roles" );
						var response = event.getPrivateValue( "response" );

						expect( response.getError() ).toBeFalse( response.getMessagesString() );
						expect( response.getData() ).toBeArray();
						expect( response.getData()[ 1 ] ).toHaveKey( "roleId" );
						expect( response.getData()[ 1 ] ).toHaveKey( "role" );
						expect( response.getPagination().totalRecords ).toBeGt( 0 );
					} );
				} );
			} );

			story( "I want to view a resource", function() {
				given( "a valid id", function() {
					then( "then I should see that resource", function() {
						var event    = this.get( "/roles/3" );
						var response = event.getPrivateValue( "response" );

						expect( response.getError() ).toBeFalse( response.getMessagesString() );
						expect( response.getData() ).toBeStruct();
						expect( response.getData().roleId ).toBe( 3 );
					} );
				} );
				given( "an invalid id", function() {
					then( "then I should see an error message", function() {
						var event    = this.get( "/roles/234234234" );
						var response = event.getPrivateValue( "response" );

						expect( response.getError() ).toBeTrue( response.getMessagesString() );
						expect( response.getData() ).toBe( 234234234 );
						expect( response.getStatusCode() ).toBe( 404 );
					} );
				} );
			} );

			story( "I want to create a resource", function() {
				given( "valid incoming data", function() {
					then( "it should create a new resource", function() {
						var event    = this.post( "/roles", { role : "unit_test" } );
						var response = event.getPrivateValue( "response" );

						// expectations go here.
						// debug( response );
						expect( response.getError() ).toBeFalse( response.getMessagesString() );
						expect( response.getData().roleId ).notToBeEmpty();
						expect( response.getData().role ).toBe( "unit_test" );
					} );
				} );

				given( "invalid data", function() {
					then( "it should display an error message", function() {
						var event    = this.post( "/roles", {} );
						var response = event.getPrivateValue( "response" );

						// expectations go here.
						// debug( response );
						expect( response.getError() ).toBeTrue( response.getMessagesString() );
						expect( response.getStatusCode() ).toBe( 400 );
					} );
				} );
			} );

			story( "I want to edit a resource", function() {
				given( "valid incoming data", function() {
					then( "it should update a role", function() {
						var event    = this.PUT( "/roles/1", { role : "unit_test" } );
						var response = event.getPrivateValue( "response" );

						// expectations go here.
						// debug( response );
						expect( response.getError() ).toBeFalse( response.getMessagesString() );
						expect( response.getData().roleId ).toBe( 1 );
						expect( response.getData().role ).toBe( "unit_test" );
					} );
				} );
				given( "an invalid id", function() {
					then( "then I should see an error message", function() {
						var event    = this.PUT( "/roles/2323", { role : "unit_test" } );
						var response = event.getPrivateValue( "response" );

						// expectations go here.
						// debug( response );
						expect( response.getError() ).toBeTrue( response.getMessagesString() );
						expect( response.getData() ).toBe( 2323 );
						expect( response.getStatusCode() ).toBe( 404 );
					} );
				} );
				given( "invalid data", function() {
					then( "it should display an error message", function() {
						var event    = this.PUT( "/roles/1", { role : "" } );
						var response = event.getPrivateValue( "response" );

						// expectations go here.
						debug( response );
						expect( response.getError() ).toBeTrue( response.getMessagesString() );
						expect( response.getData() ).toBeStruct();
						expect( response.getStatusCode() ).toBe( 400 );
					} );
				} );
			} );

			story( "I want to delete a resource", function() {
				given( "a valid id", function() {
					then( "then I should see the confirmation", function() {
						var event    = this.DELETE( "/roles/3" );
						var response = event.getPrivateValue( "response" );

						expect( response.getError() ).toBeFalse( response.getMessagesString() );
						expect( response.getStatusCode() ).toBe( 200 );
						expect( response.getMessagesString() ).toInclude( "deleted!" );
					} );
				} );
				given( "an invalid id", function() {
					then( "then I should see an error message", function() {
						var event    = this.DELETE( "/roles/2323" );
						var response = event.getPrivateValue( "response" );

						// expectations go here.
						// debug( response );
						expect( response.getError() ).toBeTrue( response.getMessagesString() );
						expect( response.getData() ).toBe( 2323 );
						expect( response.getStatusCode() ).toBe( 404 );
					} );
				} );
			} );
		} );
	}

}

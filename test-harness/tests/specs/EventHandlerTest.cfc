component extends="coldbox.system.testing.BaseInterceptorTest" interceptor="root.interceptors.ORMEventListener" {

	this.loadColdbox   = true;
	this.unLoadColdBox = false;

	function setup(){
		super.setup();

		variables.interceptorService = variables.controller.getInterceptorService();
	}

	function testORMPostLoad(){
		var called   = false;
		var listener = function( interceptData ){
			called = true;
			$assert.key( interceptData, "entity" );
			$assert.typeOf( "component", interceptData.entity );

			$assert.key( interceptData, "entityName" );
			$assert.typeOf( "string", interceptData.entityName );
			assertTrue( interceptData.entityName == "User" );
		};
		variables.interceptorService.listen( listener, "ORMPostLoad" );

		var entity = entityLoad( "User" );
		assertTrue( called );

		variables.interceptorService.unregister( "closure-ORMPostLoad-#hash( listener.toString() )#" );
	}

	function testORMPreDelete(){
		var called   = false;
		var listener = function( interceptData ){
			called = true;
			$assert.key( interceptData, "entity" );
			$assert.typeOf( "component", interceptData.entity );
		};
		variables.interceptorService.listen( listener, "ORMPreDelete" );

		var user = entityNew( "User" );
		user.setFirstName( "unitTest" );
		user.setLastName( "unitTest" );
		user.setUsername( "unitTest" );
		user.setPassword( "unitTest" );
		entitySave( user );
		ormFlush();
		entityDelete( user );
		ormFlush();

		assertTrue( called );
		variables.interceptorService.unregister( "closure-ORMPreDelete-#hash( listener.toString() )#" );
	}

	function testORMPostDelete(){
		var called   = false;
		var listener = function( interceptData ){
			called = true;
			$assert.key( interceptData, "entity" );
			$assert.typeOf( "component", interceptData.entity );
		};
		variables.interceptorService.listen( listener, "ORMPostDelete" );


		transaction {
			var user = entityNew(
				"User",
				{
					firstName : "Michael",
					lastName  : "Born",
					username  : "mbourne",
					password  : "007"
				}
			);
			entitySave( user );
			transactionCommit();
			ormFlush();
			entityDelete( user );
		}

		assertTrue( called );
		variables.interceptorService.unregister( "closure-ORMPostDelete-#hash( listener.toString() )#" );
	}

	function testORMPreUpdate(){
		var called   = false;
		var listener = function( interceptData ){
			called = true;
			$assert.key( interceptData, "entity" );
			$assert.typeOf( "component", interceptData.entity );

			$assert.key( interceptData, "oldData" );
			$assert.typeOf( "struct", interceptData.oldData );
		};
		variables.interceptorService.listen( listener, "ORMPreUpdate" );

		var user = entityNew(
			"User",
			{
				firstName : "Michael",
				lastName  : "Born",
				username  : "mbourne",
				password  : "007"
			}
		);
		entitySave( user );
		ormFlush(); // flushing throws 'Row was updated or deleted by another transaction (or unsaved-value mapping was incorrect)'
		var entity = entityLoadByPK( "User", user.getId() );
		entity.setPassword( "m0r3S3cr3tP@ssW0RD" );
		entitySave( entity );
		ormFlush();
		assertTrue( called );
		variables.interceptorService.unregister( "closure-ORMPreUpdate-#hash( listener.toString() )#" );
	}

	function testORMPostUpdate(){
		var called   = false;
		var listener = function( interceptData ){
			called = true;
			$assert.key( interceptData, "entity" );
			$assert.typeOf( "component", interceptData.entity );
		};
		variables.interceptorService.listen( listener, "ORMPostUpdate" );

		var user = entityNew(
			"User",
			{
				firstName : "Michael",
				lastName  : "Born",
				username  : "mbourne",
				password  : "007"
			}
		);
		entitySave( user );
		ormFlush();
		user.setPassword( "m0r3S3cr3tP@ssW0RD" );
		entitySave( user );
		ormFlush();
		assertTrue( called );
		variables.interceptorService.unregister( "closure-ORMPostUpdate-#hash( listener.toString() )#" );
	}

	function testORMEvict(){
		var called   = false;
		var listener = function( interceptData ){
			called = true;
			$assert.key( interceptData, "entity" );
			$assert.typeOf( "component", interceptData.entity );
		};
		variables.interceptorService.listen( listener, "ORMEvict" );

		var user = entityNew(
			"User",
			{
				firstName : "Michael",
				lastName  : "Born",
				username  : "mbourne",
				password  : "007"
			}
		);
		entitySave( user );
		ormEvictEntity( "User", user.getId() );
		assertTrue( called );
		variables.interceptorService.unregister( "closure-ORMEvict-#hash( listener.toString() )#" );
	}

	function testORMClear(){
		var called   = false;
		var listener = function( interceptData ){
			called = true;
			throw( "called!" );
			$assert.key( interceptData, "entity" );
			$assert.typeOf( "component", interceptData.entity );
		};
		variables.interceptorService.listen( listener, "ORMClear" );

		var user = entityNew( "User" );
		ormClearSession();
		assertTrue( called );
		variables.interceptorService.unregister( "closure-ORMClear-#hash( listener.toString() )#" );
	}

	function testORMFlush(){
		var called   = false;
		var listener = function( interceptData ){
			called = true;
			$assert.key( interceptData, "entity" );
			$assert.typeOf( "component", interceptData.entity );
		};
		variables.interceptorService.listen( listener, "ORMFlush" );

		var user = entityNew(
			"User",
			{
				firstName : "Michael",
				lastName  : "Born",
				username  : "mbourne",
				password  : "007"
			}
		);
		entitySave( user );
		ormFlush();
		assertTrue( called );
		variables.interceptorService.unregister( "closure-ORMFlush-#hash( listener.toString() )#" );
	}

	function onDirtyCheck(){
		// TODO: Implement me
		assertTrue( false );
	}

	function testORMAutoFlush(){
		// enable auto flush mode
		var FlushMode = createObject( "java", "org.hibernate.FlushMode" );
		ormGetSession().setFlushMode( FlushMode.AUTO );

		var called   = false;
		var listener = function( interceptData ){
			called = true;
			$assert.key( interceptData, "entity" );
			$assert.typeOf( "component", interceptData.entity );
		};
		variables.interceptorService.listen( listener, "ORMAutoFlush" );

		var user = entityNew(
			"User",
			{
				firstName : "Michael",
				lastName  : "Bourne",
				username  : "mbourne",
				password  : "007"
			}
		);
		entitySave( user );
		var newUser = entityLoad( "User", { "firstName" : "Michael" } );
		assertTrue( called );
		variables.interceptorService.unregister( "closure-ORMAutoFlush-#hash( listener.toString() )#" );
	}

}

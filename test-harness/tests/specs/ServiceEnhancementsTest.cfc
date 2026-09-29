/**
 * cborm 6 service behavior on bx-orm 2: native Java streams, criteria-backed helpers (composite ids, flushing,
 * validated sort orders), strict and first-match finders, and the thin bx-orm wrappers.
 */
component extends="tests.resources.BaseTest" {

	function setup(){
		super.setup();
		ormClearSession();
		variables.ormService = new cborm.models.BaseORMService();
		variables.testCatID  = "3A2C516C-41CE-41D3-A9224EA690ED1128";
		variables.testUserID = "88B73A03-FEFA-935D-AD8036E1B7954B76";
		// entry_categories rows (category, entry) from the fixture
		variables.link1      = {
			categoryId : "3A2C516C-41CE-41D3-A9224EA690ED1128",
			entryId    : "99fc94fd3ba7f266013bad4a8a3b0004"
		};
		variables.link2 = {
			categoryId : "5898F818-A9B6-4F5D-96FE70A31EBB78AC",
			entryId    : "99fc94fd3ba7f266013bad4a8a3b0004"
		};
	}

	function teardown(){
		ormClearSession();
	}

	/********************************* Streams *********************************/

	function testListAsStream(){
		var total  = ormService.count( "Category" );
		var stream = ormService.list( entityName = "Category", asStream = true );
		expect( stream.count() ).toBe( total );
	}

	function testExecuteQueryAsStream(){
		var total = ormService.count( "Category" );
		expect( ormService.executeQuery( query = "from Category", asStream = true ).count() ).toBe( total );
	}

	function testFindAllAndFindAllWhereAsStream(){
		expect( ormService.findAll( query = "from Category", asStream = true ).count() ).toBe(
			ormService.count( "Category" )
		);
		expect(
			ormService
				.findAllWhere(
					entityName = "Category",
					criteria   = { category : "Training" },
					asStream   = true
				)
				.count()
		).toBe( ormService.countWhere( entityName = "Category", category = "Training" ) );
	}

	function testGetAllAsStream(){
		var stream = ormService.getAll( entityName = "Category", asStream = true );
		expect( stream.count() ).toBe( ormService.count( "Category" ) );
	}

	function testStreamTakesClosures(){
		var names = ormService
			.list(
				entityName = "Category",
				sortOrder  = "category",
				asStream   = true
			)
			.map( ( c ) => c.getCategory() )
			.toList();
		expect( names.size() ).toBe( ormService.count( "Category" ) );
	}

	function testDynamicFindersAsStream(){
		expect( ormService.findAllByCategoryLike( "Category", "%", { asStream : true } ).count() ).toBe(
			ormService.count( "Category" )
		);
		expect( ormService.findByCatid( "Category", testCatID, { asStream : true } ).count() ).toBe( 1 );
	}

	/********************************* Criteria-backed helpers *********************************/

	function testExistsWithCompositeId(){
		expect( ormService.exists( "EntryCategory", link1 ) ).toBeTrue();
		expect( ormService.exists( "EntryCategory", { categoryId : "nope", entryId : "nope" } ) ).toBeFalse();
	}

	function testGetAllWithCompositeIds(){
		expect( ormService.getAll( "EntryCategory", [ link1, link2 ] ) ).toHaveLength( 2 );
		expect( ormService.getAll( "EntryCategory", link1 ) ).toHaveLength( 1 );
	}

	function testDeleteByIDWithCompositeId(){
		withRollback( () => {
			expect( ormService.deleteByID( "EntryCategory", link1 ) ).toBe( 1 );
			expect( ormService.exists( "EntryCategory", link1 ) ).toBeFalse();
		} );
	}

	function testGetAllSortOrderCannotInjectHQL(){
		expect( () => ormService.getAll( entityName = "Category", sortOrder = "category; delete from User" ) ).toThrow();
		expect( () => ormService.getAll(
			entityName = "Category",
			properties = "catid as id",
			sortOrder  = "category, (select 1)"
		) ).toThrow( "InvalidSortOrder" );
		expect( ormService.getAll( entityName = "Category", sortOrder = "category desc" ) ).notToBeEmpty();
	}

	function testDynamicFinderSortByCannotInjectHQL(){
		expect( () => ormService.findAllByCategoryLike(
			"Category",
			"%",
			{ sortBy : "category; delete from User" }
		) ).toThrow( "InvalidSortOrder" );
		expect( ormService.findAllByCategoryLike( "Category", "%", { sortBy : "category desc" } ) ).notToBeEmpty();
	}

	function testDeleteWhereFlushesPendingChangesFirst(){
		withRollback( () => {
			var cat = ormService.new( "Category", { category : "unitTestFlush", description : "pending" } );
			ormService.save( cat );
			// Not flushed yet: the bulk delete flushes it first, so it is found and deleted
			expect( ormService.deleteWhere( entityName = "Category", category = "unitTestFlush" ) ).toBe( 1 );
		} );
	}

	function testCountWhereValidatesProperties(){
		expect( ormService.countWhere( entityName = "Category", category = "Training" ) ).toBeGT( 0 );
		expect( () => ormService.countWhere( entityName = "Category", bogus = 1 ) ).toThrow( "orm.property.unknown" );
	}

	function testFindAllByIdInList(){
		expect( ormService.findAllByCatidInList( "Category", testCatID ) ).toHaveLength( 1 );
	}

	/********************************* Finders *********************************/

	function testFindWhereIsStrictUnlessUniqueFirst(){
		expect( () => ormService.findWhere( "User", {} ) ).toThrow( "orm.query.nonUnique" );
		expect( ormService.findWhere( "User", {}, { uniqueFirst : true } ) ).toBeComponent();
	}

	function testFindWhereOrFail(){
		expect( ormService.findWhereOrFail( "Category", { catid : testCatID } ).getCatid() ).toBe( testCatID );
		expect( () => ormService.findWhereOrFail( "Category", { category : "does-not-exist" } ) ).toThrow( "EntityNotFound" );
	}

	function testFindItTakesTheFirstMatch(){
		expect( ormService.findIt( "from User" ) ).toBeComponent();
	}

	function testFirstOrNew(){
		var found = ormService.firstOrNew( "Category", { catid : testCatID } );
		expect( found.getCatid() ).toBe( testCatID );

		var fresh = ormService.firstOrNew(
			"Category",
			{ category : "unitTestNew" },
			{ description : "new one" }
		);
		expect( isNull( fresh.getCatid() ) ).toBeTrue();
		expect( fresh.getCategory() ).toBe( "unitTestNew" );
		expect( fresh.getDescription() ).toBe( "new one" );
	}

	function testFirstOrCreate(){
		withRollback( () => {
			var created = ormService.firstOrCreate(
				"Category",
				{ category : "unitTestCreate" },
				{ description : "created" },
				true
			);
			expect( created.getCatid() ).notToBeEmpty();
			expect( ormService.countWhere( entityName = "Category", category = "unitTestCreate" ) ).toBe( 1 );
			// Found the second time, not created again
			var again = ormService.firstOrCreate( "Category", { category : "unitTestCreate" } );
			expect( again.getCatid() ).toBe( created.getCatid() );
		} );
	}

	function testExecuteQueryAsQueryWithUpdateInTheText(){
		// A select mentioning "update " is still a select
		var results = ormService.executeQuery(
			query   = "from Category where description <> 'update me' ",
			asQuery = true
		);
		expect( isQuery( results ) ).toBeTrue();
	}

	/********************************* bx-orm wrappers *********************************/

	function testGetWithOptions(){
		var cat = ormService.get(
			"Category",
			testCatID,
			true,
			{ readOnly : true }
		);
		expect( cat.getCatid() ).toBe( testCatID );
	}

	function testGetReference(){
		expect( ormService.getReference( "Category", testCatID ).getCatid() ).toBe( testCatID );
	}

	function testReadOnly(){
		var cat = ormService.readOnly( () => ormService.get( "Category", testCatID ) );
		expect( cat.getCatid() ).toBe( testCatID );
	}

	function testLock(){
		withRollback( () => {
			var cat = ormService.get( "Category", testCatID );
			expect( ormService.lock( cat, "write" ).getCatid() ).toBe( testCatID );
		} );
	}

	function testUpdateWhere(){
		withRollback( () => {
			var count = ormService.updateWhere(
				"Category",
				{ catid : testCatID },
				{ description : "updated" }
			);
			expect( count ).toBe( 1 );
			ormClearSession();
			expect( ormService.get( "Category", testCatID ).getDescription() ).toBe( "updated" );
		} );
		expect( () => ormService.updateWhere( "Category", {}, { description : "x" } ) ).toThrow(
			"BaseORMService.NoWhereArgumentsFound"
		);
	}

	/********************************* Fixes *********************************/

	function testNewLeavesNoFlagBehind(){
		ormService.new( "Category" );
		expect( request.keyExists( "cbormEntityNewInProgress" ) ).toBeFalse();
	}

	function testVirtualServiceFixes(){
		var service = new cborm.models.VirtualEntityService( "Category" );
		// evictCollection returns the service for chaining
		expect( service.evictCollection() ).toBeComponent();
		// deleteAll passes transactional through
		withRollback( () => {
			var links = new cborm.models.VirtualEntityService( "EntryCategory" );
			expect( links.deleteAll( transactional = false ) ).toBeGT( 0 );
		} );
		// signatures match the base service
		expect( service.findAllWhere( { category : "Training" }, "", true, 0, false ) ).toBeArray();
		expect( service.new( properties = { category : "x" }, ignoreTargetLists = true ).getCategory() ).toBe( "x" );
	}

	function testDynamicProcessorClearCache(){
		var processor = getWireBox().getInstance( "cborm.models.util.DynamicProcessor" );
		ormService.findAllByCategory( "Category", "Training" );
		expect( processor.getHQLDynamicCache() ).notToBeEmpty();
		processor.clearCache();
		expect( processor.getHQLDynamicCache() ).toBeEmpty();
		// And it compiles again
		expect( ormService.findAllByCategory( "Category", "Training" ) ).notToBeEmpty();
	}

	function testEntityNewIsAutowired(){
		// bx-orm's entityNew() fires postNew, which autowires like postLoad does
		expect( isNull( entityNew( "User" ).getTestDI() ) ).toBeFalse();
	}

	function testInjectionIncludeMatchesWholeNames(){
		var settings = getController().getConfigSettings().modules[ "cborm" ].settings;
		var original = duplicate( settings.injection );
		try {
			// "User" is not in the include list "UserRole": not autowired
			settings.injection.include = "UserRole";
			expect( isNull( entityNew( "User" ).getTestDI() ) ).toBeTrue();
		} finally {
			settings.injection = original;
		}
	}

	/********************************* ActiveEntity *********************************/

	function testActiveEntityValidationResult(){
		var user = entityNew( "ActiveUser" );
		expect( user.isValid() ).toBeFalse();
		// The validationResult property accessor and getValidationResults() return the same result
		expect( user.getValidationResult() ).toBeComponent();
		expect( user.getValidationResults().hasErrors() ).toBeTrue();
	}

	function testActiveEntityIsValidHonorsIncludeFields(){
		var user = entityNew( "ActiveUser" );
		user.setFirstName( "Luis" );
		// Only firstName is validated
		expect( user.isValid( includeFields = "firstName" ) ).toBeTrue();
	}

	function testActiveEntityDefaultsToItself(){
		var user = entityLoad( "ActiveUser", testUserID, true );
		expect( user.getKeyValue() ).toBe( testUserID );
		expect( user.sessionContains() ).toBeTrue();
		expect( user.getDirtyPropertyNames() ).toBeArray();
		expect( user.toStruct() ).toBeStruct();
	}

}

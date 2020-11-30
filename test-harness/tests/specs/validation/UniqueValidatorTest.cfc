component extends="tests.resources.BaseTest"{

	function setup() {
		super.setup();

		model = getWireBox().getInstance( "UniqueValidator@cborm" );
	}

	function testValidate() {
		result       = getMockBox().createMock( "cbvalidation.models.result.ValidationResult" ).init();
		var category = entityNew( "Category" );

		// null
		r = model.validate(
			result,
			category,
			"category",
			javacast( "null", "" ),
			"true"
		);
		assertEquals( true, r );

		// 1: No ID, Unique
		r = model.validate(
			result,
			category,
			"category",
			"luis",
			"true"
		);
		assertEquals( true, r );
		// 2: No ID, Not Unique
		r = model.validate(
			result,
			category,
			"category",
			"ColdBox",
			"true"
		);
		assertEquals( false, r );

		var category = entityLoad(
			"Category",
			{ category : "ColdBox" },
			true
		);
		// 3: With ID, the same
		r = model.validate(
			result,
			category,
			"category",
			"ColdBox",
			"true"
		);
		assertEquals( true, r );
		// 3: With ID, and unique
		r = model.validate(
			result,
			category,
			"category",
			"THIS IS UNIQUE",
			"true"
		);
		assertEquals( true, r );
		// 4: With ID, and NOT unique
		r = model.validate(
			result,
			category,
			"category",
			"News",
			"true"
		);
		assertEquals( false, r );
	}

}

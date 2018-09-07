/**
* My Event Handler Hint
*/
component{

	property name="userService" inject="entityService:User";

	// Index
	any function index( event,rc, prc ){
	}

	// Run on first init
	any function onAppInit( event, rc, prc ){
	}

	/**
	* uniqueValidation
	*/
	any function uniqueValidation( event, rc, prc ){

		var vResults = validateModel( target=userService.new( {
			firstName="luis", lastName="majano", username="#createUUID()#"
		} ) );

		return {
			"hasErrors" : vResults.hasErrors(),
			"errors" : vResults.getAllErrors()
		};
	}

	/**
	* notUniqueValidation
	*/
	any function notUniqueValidation( event, rc, prc ){

		var vResults = validateModel( target=userService.new( {
			firstName="luis", lastName="majano", username="lui"
		} ) );

		return {
			"hasErrors" : vResults.hasErrors(),
			"errors" : vResults.getAllErrors()
		};
	}

}
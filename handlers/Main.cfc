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
		
		var vResults = validateModel( target=userService.new( { firstName="luis", lastName="majano", username="#createUUID()#" } ) );
		event.renderData( data=vResults.getAllErrors(), type="json" );
	}

	/**
	* notUniqueValidation
	*/
	any function notUniqueValidation( event, rc, prc ){
		
		var vResults = validateModel( target=userService.new( { firstName="luis", lastName="majano", username="lui" } ) );
		event.renderData( data=vResults.getAllErrors(), type="json" );
	}

}
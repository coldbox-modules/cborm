/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * This class resolves all kinds of dynamic finders and counters using ORM
 */
import cborm.models.util.*;

component accessors="true"{

	/**
	 * All calculated and parsed dynamic finders' and counters' HQL will be stored here for easier execution
	 */
	property name="HQLDynamicCache" type="struct" persistent="false";

	/************************************** STATIC VARIABLES *********************************************/

	// STATIC DYNAMIC FINDER VARIABLES
	variables.ALL_CONDITIONALS 			= "LessThanEquals,LessThan,GreaterThanEquals,GreaterThan,Like,NotEqual,isNull,isNotNull,NotBetween,Between,NotInList,inList";
	variables.ALL_CONDITIONALS_REGEX	= replace( variables.ALL_CONDITIONALS, ",", "|", "all" );
	variables.CONDITIONALS_SQL_MAP 		= {
		"LessThanEquals" = "<=",
		"LessThan" = "<",
		"GreaterThanEquals" = ">=",
		"GreaterThan" = ">",
		"Like" = "like",
		"NotEqual" = "<>",
		"isNull" = "is null",
		"isNotNull" = "is not null",
		"NotBetween" = "not between",
		"between" = "between",
		"NotInList" = "not in",
		"InList" = "in"
	};
	variables.OPTIONS_KEYS = "ignoreCase,maxResults,offset,cacheable,cacheName,timeout,datasource,sortBy";
	variables.OPTIONS_KEYS_REGEX = replace( variables.OPTIONS_KEYS, ",", "|", "all" );

	/**
	 * Constructor
	 *
	 * @baseService The base service that initiated the dynamic methods
	 */
	function init( required baseService ){
		variables.baseService 		= arguments.baseService;
		variables.HQLDynamicCache	= {};
		variables.logger 			= arguments.baseService.getWireBox().getLogBox().getLogger( this );
		return this;
	}


	/**
	 * A method for finding entity's dynamically, for example:
	 * findByLastNameAndFirstName('User', 'Tester', 'Test');
	 * findByLastNameOrFirstName('User', 'Tester', 'Test')
	 * findAllByLastNameIsNotNull('User');
	 * The first argument must be the 'entityName' or a named agument called 'entityname'
	 * Any argument which is a structure will be used as options for the query: { ignorecase, maxresults, offset, cacheable, cachename, timeout }
	 *
	 * @method The method used
	 * @args The args used
	 * @unique Are we finding one or more items
	 * @isCounting Are finding or counting
	 *
	 * @throws NonUniqueResultException, HQLQueryException
	 */
	any function findDynamically(
		string method,
		struct args,
		boolean unique=true,
		boolean isCounting=false
	){
		// Setup the call hash
		var dynamicCacheKey = hash( arguments.toString() );

		// setup the params to bind from the arguments, and also distinguish the incoming query options
		var params 	= {};
		var options = arguments.args.options ?: {};

		// Verify entityName, if does not exist, use the first argument.
		if( isNull( arguments.args.entityName ) ){
			arguments.entityName = args[ 1 ];
			// Remove it like a mighty ninja
			structDelete( arguments.args, "1" );
		} else {
			arguments.entityName = arguments.args.entityName;
			// Remove it like a mighty ninja
			structDelete( arguments.args, "entityName" );
		}

		// Process arguments to binding parameters, we use named as they bind better in HQL, go figure
		for(var i=1; i LTE ArrayLen( arguments.args ); i++ ){
			// Check if the argument is a structure, if it is, then these are the query options
			if( isOptionsStruct( arguments.args[ i ] ) ){
				options = arguments.args[ i ];
			}
			// Normal params
			else{
				params[ "param#i#" ] = arguments.args[ i ];
			}
		}

		// add datasource to options for multi datasource orm
		options[ "datasource" ] = variables.baseService.getDatasource();

		// Check if we have already the signature for this request
		if( structKeyExists( variables.HQLDynamicCache, dynamicCacheKey ) ){
			var hql = variables.HQLDynamicCache[ dynamicCacheKey ];
		} else {
			arguments.params = params;
			var hql = compileHQLFromDynamicMethod( argumentCollection=arguments );
			// store compiled HQL
			variables.HQLDynamicCache[ dynamicCacheKey ] = hql;
		}

		//results struct used for testing
		var results = {
			"method"     : arguments.method,
			"params"     : params,
			"options"    : options,
			"unique"     : arguments.unique,
			"isCounting" : arguments.isCounting,
			"hql"        : hql
		};

		// Sorting Enabled
		if( !isNull( options.sortBy ) ){
			hql &= " ORDER BY #options.sortBy#";
		}


		// Logging
		if( variables.logger.canDebug() ){
			variables.logger.debug( "Dynamic method requested: #arguments.method# with the following bindings:", results );
		}

		try{

			return ORMExecuteQuery( hql, params, arguments.unique, options );

		} catch( Any e ) {
			if( findNoCase( "org.hibernate.NonUniqueResultException", e.detail ) ){
		 		throw(
					message = e.message & e.detail,
					detail  = "If you do not want unique results then use 'FindAllBy' instead of 'FindBy'",
					type    = "NonUniqueResultException"
				);
			}
			throw(
				message = e.message & e.detail,
				type    = "HQLQueryException",
				detail  = "Dynamic compiled query: #results.toString()#"
			);
		}

	}

	/**
	 * Is the passed in target an options struct or not
	 *
	 * @target The target to test
	 */
	private boolean function isOptionsStruct( required target ){
		if( isStruct( arguments.target ) ){
			return structKeyArray( target )
				.filter( function( item ){
					return listFindNoCase( variables.OPTIONS_KEYS, item ) > 0;
				} )
				.len() > 0;
		}

		return false;
	}

	/**
	 * Compile HQL from a dynamic method call
	 */
	private any function compileHQLFromDynamicMethod(
		string method,
		struct args,
		boolean unique=true,
		boolean isCounting=false,
		struct params,
		entityName
	){
		// Get all real property names
		var realPropertyNames = variables.baseService.getPropertyNames( arguments.entityName );

		// Match our method grammars in the method string
		var methodGrammars = REMatchNoCase(
			"(#arrayToList( realPropertyNames, '|' )#)+(#variables.ALL_CONDITIONALS_REGEX#)?(and|or|$)",
			arguments.method
		);

		// Throw exception if no method grammars found
		if( !arrayLen( methodGrammars ) ){
			throw(
				message = "Invalid dynamic method grammar expression. Please check your syntax. You could be missing property names or conditionals",
				detail 	= "Expression: #arguments.method#",
				type 	= "InvalidMethodGrammar"
			);
		}

		// Iterate over method grammars to build HQL Expressions
		var HQLExpressions = [];
		for( var thisGrammar in methodGrammars ){
			// create expression syntax
			var expression = { property = "", conditional = "eq", operator = "and", sql = "=" };

			// Check for Or expression, AND is default expression
			if( right( thisGrammar, 2 ) eq "or" ){
				expression.operator = "or";
			}

			// Remove operators now that we have it, if the property name doesn't exist
			if( !arrayFindNoCase( realPropertyNames, thisGrammar ) ) {
				thisGrammar = REReplacenoCase( thisGrammar, "(and|or)$", "" );
			}

			// Get property by removing conditionals from the expression
			expression.property = REReplacenoCase( thisGrammar, "(#variables.ALL_CONDITIONALS_REGEX#)$", "" );

			// Verify if property exists in valid properties
			var realPropertyIndex = arrayFindNoCase( realPropertyNames, expression.property );
			if( realPropertyIndex EQ 0 ){
				throw(
					message	= "The property you requested '#expression.property#' is not a valid property in the '#arguments.entityName#' entity",
					detail	= "Valid properties are #arrayToList( realPropertyNames )#",
					type 	= "InvalidEntityProperty"
				);
			}
			// now save the actual property name to the passed in property to avoid case issues with Hibernate
			expression.property = realPropertyNames[ realPropertyIndex ];
			// Remove property now from method expression
			thisGrammar = REReplacenoCase( thisGrammar, "#expression.property#", "" );

			// Get Conditional Operator now if it exists, else it defaults to EQ
			if( len( thisGrammar ) ){
				// Match the conditional statement
				var conditional = REMatchNoCase( "(#variables.ALL_CONDITIONALS_REGEX#)$", thisGrammar );
				// Did we match?
				if( arrayLen( conditional ) ){
					expression.conditional = conditional[ 1 ];
					expression.sql = variables.CONDITIONALS_SQL_MAP[ expression.conditional ];
				} else {
					throw(
						message = "Invalid conditional statement in method expression: #thisGrammar#",
						detail  = "Valid Conditionals: #variables.ALL_CONDITIONALS#",
						type    = "InvalidConditionalExpression"
					);
				}
			}

			// Add to expressions
			arrayAppend( HQLExpressions, expression );
		}

		// end compile grammars
		return compileHQL(
			HQLExpressions,
			arguments.isCounting,
			arguments.entityName,
			arguments.params
		);
	}

	/**
	 * This method compiles the Hibernate HQL from a given array of expression objects
	 * Each expression object contains the following
	 *
	 * <pre>
	 * { property = "", conditional = "eq", operator = "and", sql = "=" };
	 * </pre>
	 *
	 * @HQLExpressions The array of expression to compile to HQL
	 * @isCounting Are we counting or finding?
	 * @entityName The entity name
	 */
	private function compileHQL(
		required array HQLExpressions,
		boolean isCounting,
		string entityName,
		struct params
	){
		// Build the HQL
		var where = "";
		// Begin building the hql statement with or without counts
		var hql = "";
		if( arguments.isCounting ){
			hql &= "select count( id ) ";
		}
		hql &= "from " & arguments.entityName;

		var paramIndex = 1;
		for( var thisExpression in arguments.HQLExpressions ){

			if( len( where ) ){
				where = "#where# #thisExpression.operator# ";
			}

			switch( trim( thisExpression.conditional ) ){
				case "isNull" : case "isNotNull" : {
					where = "#where# #thisExpression.property# #thisExpression.sql#";
					break;
				}
				case "between" : case "notBetween" : {
					where = "#where# #thisExpression.property# #thisExpression.sql# :param#paramIndex++# and :param#paramIndex++#";
					break;
				}
				case "inList" : case "notInList" : {
					where = "#where# #thisExpression.property# #thisExpression.sql# (:param#paramIndex++#)";
					// Verify if the param is an array collection
					if( isSimpleValue( arguments.params[ "param#paramIndex - 1#" ] ) ){
						arguments.params[ "param#paramIndex - 1#" ] = listToArray( params["param#paramIndex-1#"] );
					}
					break;
				}
				default : {
					where = "#where# #thisExpression.property# #thisExpression.sql# :param#paramIndex++#";
					break;
				}
			}
		}

		// Finalize the HQL
		return hql & " where #where#";
	}


}
/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * A proxy to hibernate org.hibernate.criterion.Restrictions object to allow for criteria based querying
 *
 * @see https://docs.jboss.org/hibernate/stable/orm/javadocs/org/hibernate/criterion/Restrictions.html
 */
component singleton access="true" {

	/**
	 * The java proxy builder
	 */
	property name="javaProxy";

	// Lookup map of Hibernate to CF Types. Used for auto casting.
	this.TYPES = {
		"string"       : "StringType",
		"clob"         : "ClobType",
		"text"         : "TextType",
		"char"         : "ChareacterType",
		"boolean"      : "BooleanType",
		"yesno"        : "YesNoType",
		"truefalse"    : "TrueFalseType",
		"byte"         : "ByteType",
		"short"        : "ShortType",
		"integer"      : "IntegerType",
		"long"         : "LongType",
		"float"        : "FloatType",
		"double"       : "DoubleType",
		"bigInteger"   : "BigIntegerType",
		"bigDecimal"   : "BigDecimalType",
		"timestamp"    : "TimestampType",
		"time"         : "TimeType",
		"date"         : "DateType",
		"calendar"     : "CalendarType",
		"currency"     : "CurrencyType",
		"locale"       : "LocaleType",
		"timezone"     : "TimeZoneType",
		"url"          : "UrlType",
		"class"        : "ClassType",
		"blob"         : "BlobType",
		"binary"       : "BinaryType",
		"uuid"         : "UUIDCharType",
		"serializable" : "SerializableType"
	};

	/**
	 * Constructor
	 *
	 * @javaProxy.inject JavaProxyBuilder@cborm
	 */
	Restrictions function init( required javaProxy ){
		variables.javaProxy    = arguments.javaProxy;
		variables.restrictions = arguments.javaProxy.build( "org.hibernate.criterion.Restrictions" );
		return this;
	}

	/**
	 * Get the native hibernate restrictions object: org.hibernate.criterion.Restrictions
	 *
	 * @return org.hibernate.criterion.Restrictions
	 */
	function getNativeClass(){
		return variables.restrictions;
	}

	/**
	 * Where the property value is between two distinct values
	 *
	 * @property The target property
	 * @minValue The min value
	 * @maxValue The max value
	 */
	any function between(
		required string property,
		required any minValue,
		required any maxValue
	){
		return variables.restrictions.between(
			arguments.property,
			arguments.minValue,
			arguments.maxValue
		);
	}

	/**
	 * Where a property equals a particular value, you can also use eq()
	 *
	 * @property      The target property
	 * @propertyValue The value
	 */
	any function isEq( required string property, required any propertyValue ){
		return variables.restrictions.eq( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where a property is true
	 *
	 * @property
	 */
	any function isTrue( required string property ){
		return variables.restrictions.eq( arguments.property, javacast( "boolean", true ) );
	}

	/**
	 * Where a property is false
	 *
	 * @property
	 */
	any function isFalse( required string property ){
		return variables.restrictions.eq( arguments.property, javacast( "boolean", false ) );
	}

	/**
	 * Where one property must equal another
	 *
	 * @property     
	 * @otherProperty
	 */
	any function eqProperty( required string property, required string otherProperty ){
		return variables.restrictions.eqProperty( arguments.property, arguments.otherProperty );
	}

	/**
	 * Where a property is greater than a particular value, you can also use gt()
	 *
	 * @property     
	 * @otherProperty
	 */
	any function isGt( required string property, required any propertyValue ){
		return variables.restrictions.gt( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where a one property must be greater than another
	 *
	 * @property     
	 * @otherProperty
	 */
	any function gtProperty( required string property, required string otherProperty ){
		return variables.restrictions.gtProperty( arguments.property, arguments.otherProperty );
	}

	/**
	 * Where a property is greater than or equal to a particular value, you can also use ge()
	 *
	 * @property     
	 * @propertyValue
	 */
	any function isGe( required string property, required any propertyValue ){
		return variables.restrictions.ge( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where a one property must be greater than or equal to another
	 *
	 * @property     
	 * @otherProperty
	 */
	any function geProperty( required string property, required string otherProperty ){
		return variables.restrictions.geProperty( arguments.property, arguments.otherProperty );
	}

	/**
	 * Where an objects id equals the specified value
	 *
	 * @property     
	 * @propertyValue
	 */
	any function idEQ( required any propertyValue ){
		return variables.restrictions.idEQ( arguments.propertyValue );
	}

	/**
	 * A case-insensitive 'like' expression
	 */
	any function ilike( required string property, required string propertyValue ){
		return variables.restrictions.ilike( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where a property is contained within the specified list of values, the property value can be a collection (struct) or array or list, you can also use in()
	 *
	 * @property     
	 * @propertyValue
	 */
	any function isIn( required string property, required any propertyValue ){
		// infalte to array if simple values
		if ( isSimpleValue( arguments.propertyValue ) ) {
			arguments.propertyValue = listToArray( arguments.propertyValue );
		}
		return variables.restrictions.in( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where a collection property is empty
	 *
	 * @property
	 */
	any function isEmpty( required string property ){
		return variables.restrictions.isEmpty( arguments.property );
	}

	/**
	 * Where a collection property is not empty
	 *
	 * @property
	 */
	any function isNotEmpty( required string property ){
		return variables.restrictions.isNotEmpty( arguments.property );
	}

	/**
	 * Where a property is null
	 */
	any function isNull( required string property ){
		return variables.restrictions.isNull( arguments.property );
	}

	/**
	 * Where a property is not null
	 *
	 * @property     
	 * @propertyValue
	 */
	any function isNotNull( required string property ){
		return variables.restrictions.isNotNull( arguments.property );
	}

	/**
	 * Where a property is less than a particular value, you can also use lt()
	 *
	 * @property     
	 * @propertyValue
	 */
	any function islt( required string property, required any propertyValue ){
		return variables.restrictions.lt( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where a one property must be less than another
	 *
	 * @property     
	 * @propertyValue
	 */
	any function ltProperty( required string property, required string otherProperty ){
		return variables.restrictions.ltProperty( arguments.property, arguments.otherProperty );
	}

	/**
	 * Where a property is less than or equal a particular value, you can also use le()
	 *
	 * @property     
	 * @propertyValue
	 */
	any function isle( required string property, required any propertyValue ){
		return variables.restrictions.le( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where a one property must be less than or equal to another
	 *
	 * @property     
	 * @otherProperty
	 */
	any function leProperty( required string property, required string otherProperty ){
		return variables.restrictions.leProperty( arguments.property, arguments.otherProperty );
	}

	/**
	 * Equivalent to SQL like expression
	 *
	 * @property     
	 * @propertyValue
	 */
	any function like( required string property, required string propertyValue ){
		return variables.restrictions.like( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where a property does not equal a particular value
	 *
	 * @property     
	 * @propertyValue
	 */
	any function ne( required string property, required any propertyValue ){
		return variables.restrictions.ne( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where one property does not equal another
	 *
	 * @property     
	 * @propertyValue
	 */
	any function neProperty( required string property, required any otherProperty ){
		return variables.restrictions.neProperty( arguments.property, arguments.otherProperty );
	}

	/**
	 * Where a collection property's size equals a particular value
	 *
	 * @property     
	 * @propertyValue
	 */
	any function sizeEq( required string property, required any propertyValue ){
		return variables.restrictions.sizeEq( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where a collection property's size is greater than a particular value
	 *
	 * @property     
	 * @propertyValue
	 */
	any function sizeGT( required string property, required any propertyValue ){
		return variables.restrictions.sizeGT( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where a collection property's size is greater than or equal a particular value
	 *
	 * @property     
	 * @propertyValue
	 */
	any function sizeGE( required string property, required any propertyValue ){
		return variables.restrictions.sizeGE( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where a collection property's size is less than a particular value
	 *
	 * @property     
	 * @propertyValue
	 */
	any function sizeLT( required string property, required any propertyValue ){
		return variables.restrictions.sizeLT( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where a collection property's size is less than or equal a particular value
	 *
	 * @property     
	 * @propertyValue
	 */
	any function sizeLE( required string property, required any propertyValue ){
		return variables.restrictions.sizeLE( arguments.property, arguments.propertyValue );
	}

	/**
	 * Where a collection property's size is not equal to a particular value
	 *
	 * @property     
	 * @propertyValue
	 */
	any function sizeNE( required string property, required any propertyValue ){
		return variables.restrictions.sizeNE( arguments.property, arguments.propertyValue );
	}

	/**
	 * Build out a Hibernate Type
	 * https://vladmihalcea.com/a-beginners-guide-to-hibernate-types/
	 *
	 * @type The class type to build: StringType, BooleanType, YesNoType, LongType
	 */
	function buildHibernateType( required type ){
		var javaType = variables.javaProxy.build( "org.hibernate.type.#arguments.type#" );
		// Return the Adobe or Lucee Approach of the instance type
		return server.keyExists( "lucee" ) ? javaType : javaType.INSTANCE;
	}

	/**
	 * Use arbitrary SQL to modify the resultset
	 *
	 * @sql    The sql to execute, it can contain parameters via positional `?` placeholders
	 * @params This is an array of value definitions which need to be a struct of { value: , type: } or if the value is a simple value, we will try to infer it's type
	 */
	function sql( required string sql, array params = [] ){
		// No params, just execute
		if ( !params.len() ) {
			return variables.restrictions.sqlRestriction( arguments.sql );
		}

		// Discover Types, not perfect, but hey :)
		var discoverType = function( target ){
			if ( isValid( "Binary", arguments.target ) ) {
				return buildHibernateType( this.TYPES[ "binary" ] );
			}
			if ( isValid( "Boolean", arguments.target ) ) {
				return buildHibernateType( this.TYPES[ "boolean" ] );
			}
			if ( isValid( "time", arguments.target ) ) {
				return buildHibernateType( this.TYPES[ "time" ] );
			}
			if ( isValid( "date", arguments.target ) ) {
				return buildHibernateType( this.TYPES[ "timestamp" ] );
			}
			if ( isValid( "uuid", arguments.target ) ) {
				return buildHibernateType( this.TYPES[ "uuid" ] );
			}
			if ( isValid( "float", arguments.target ) ) {
				return buildHibernateType( this.TYPES[ "float" ] );
			}
			if ( isValid( "numeric", arguments.target ) ) {
				return buildHibernateType( this.TYPES[ "integer" ] );
			}
			if ( isValid( "url", arguments.target ) ) {
				return buildHibernateType( this.TYPES[ "url" ] );
			}
			if ( len( arguments.target ) <= 255 ) {
				return buildHibernateType( this.TYPES[ "string" ] );
			} else {
				return buildHibernateType( this.TYPES[ "text" ] );
			}
		};

		// Build out types
		var types  = [];
		var values = arguments.params.map( function( item ){
			// Infer the Type if just the value
			if ( isSimpleValue( item ) ) {
				var thisType = discoverType( item );
				types.append( thisType );
				return thisType.fromStringValue( item );
			}
			// Else Strict Types: { value, type }
			else {
				var thisType = buildHibernateType( this.TYPES[ item.type ] );
				types.append( thisType );
				return thisType.fromStringValue( item.value );
			}
		} );

		// Return with values and types
		return variables.restrictions.sqlRestriction( arguments.sql, values, types );
	}

	/**
	 * Use arbitrary SQL to modify the resultset
	 *
	 * @deprecated Use the `sql()` function instead
	 * @sql        The sql to execute, it can contain parameters via positional `?` placeholders
	 * @params     This is an array of value definitions which need to be a struct of { value: , type: } or if the value is a simple value, we will try to infer it's type
	 */
	any function sqlRestriction( required string sql, array params = [] ){
		return this.sql( argumentCollection = arguments );
	}

	/**
	 * Group expressions together in a single conjunction (A and B and C...) and return the conjunction
	 *
	 * @restrictionValues
	 */
	any function conjunction( required array restrictionValues ){
		var cj = variables.restrictions.conjunction();

		for ( var i = 1; i LTE arrayLen( arguments.restrictionValues ); i++ ) {
			cj.add( arguments.restrictionValues[ i ] );
		}

		return cj;
	}

	/**
	 * Return the conjuction of N expressions as arguments
	 */
	any function $and(){
		var expressions = [];
		for ( var key in arguments ) {
			arrayAppend( expressions, arguments[ key ] );
		}
		return this.conjunction( expressions );
	}

	/**
	 * Return the disjunction of N expressions as arguments
	 */
	any function $or(){
		var expressions = [];
		for ( var key in arguments ) {
			arrayAppend( expressions, arguments[ key ] );
		}
		return this.disjunction( expressions );
	}

	/**
	 * Group expressions together in a single disjunction (A or B or C...)
	 *
	 * @restrictionValues
	 */
	any function disjunction( required array restrictionValues ){
		var dj = variables.restrictions.disjunction();

		for ( var i = 1; i LTE arrayLen( arguments.restrictionValues ); i++ ) {
			dj.add( arguments.restrictionValues[ i ] );
		}

		return dj;
	}

	/**
	 * Return the negation of an expression
	 *
	 * @criterion
	 */
	any function isNot( required any criterion ){
		return variables.restrictions.not( arguments.criterion );
	}

	/**
	 * If a method does not exist, we will try to match it to a Hibernate native function, if not an exception is thrown
	 *
	 * @missingMethodName
	 *
	 * @throws RuntimeException
	 */
	any function onMissingMethod( required string missingMethodName, required struct missingMethodArguments ){
		// detect dynamic negation
		if ( left( arguments.missingMethodName, 3 ) eq "not" && len( arguments.missingMethodName ) > 3 ) {
			// remove NOT
			arguments.missingMethodName = right(
				arguments.missingMethodName,
				len( arguments.missingMethodName ) - 3
			);
			return this.isNot(
				invoke(
					this,
					arguments.missingMethodName,
					missingMethodArguments
				)
			);
		}

		// Aliases
		switch ( arguments.missingMethodName ) {
			case "eq":
				return isEq( argumentCollection = arguments.missingMethodArguments );
				break;
			case "in":
				return isIn( argumentCollection = arguments.missingMethodArguments );
				break;
			case "gt":
				return isGt( argumentCollection = arguments.missingMethodArguments );
				break;
			case "lt":
				return isLT( argumentCollection = arguments.missingMethodArguments );
				break;
			case "le":
				return isLE( argumentCollection = arguments.missingMethodArguments );
				break;
			case "ge":
				return isGe( argumentCollection = arguments.missingMethodArguments );
				break;
			case "and":
				return $and( argumentCollection = arguments.missingMethodArguments );
				break;
			case "or":
				return $or( argumentCollection = arguments.missingMethodArguments );
				break;
			case "not":
				return isNot( argumentCollection = arguments.missingMethodArguments );
				break;
			default: {
				// Funnel call to native class, if it throws an exepction, well, so be it!
				return invoke(
					variables.restrictions,
					arguments.missingMethodName,
					arguments.missingMethodArguments
				);
			}
		}
	}

}

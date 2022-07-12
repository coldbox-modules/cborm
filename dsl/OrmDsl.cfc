/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * The ORM WireBox DSL
 */
component accessors="true" {

	property name="injector";

	/**
	 * Constructor as per interface
	 */
	public any function init( required any injector ){
		variables.injector = arguments.injector;
		return this;
	}

	/**
	 * Process an incoming DSL definition and produce an object with it
	 *
	 * @definition   The injection dsl definition structure to process. Keys: name, dsl
	 * @targetObject The target object we are building the DSL dependency for. If empty, means we are just requesting building
	 * @targetID     The target ID we are building this dependency for
	 *
	 * @return coldbox.system.ioc.dsl.IDSLBuilder
	 */
	function process( required definition, targetObject, targetID ){
		var DSLNamespace = listFirst( arguments.definition.dsl, ":" );

		switch ( DSLNamespace ) {
			case "entityService": {
				return getEntityServiceDSL( argumentCollection = arguments );
			}
		}
	}

	/**
	 * Get an EntityService Dependency
	 */
	function getEntityServiceDSL( required definition, targetObject ){
		var entityName = getToken( arguments.definition.dsl, 2, ":" );

		// Do we have an entity name? If we do create virtual entity service
		if ( len( entityName ) ) {
			return new cborm.models.VirtualEntityService( entityName );
		}

		// else return Base ORM Service
		return new cborm.models.BaseORMService();
	}

}

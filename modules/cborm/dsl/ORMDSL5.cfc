/********************************************************************************
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
********************************************************************************
* The ORM WireBox DSL
*/
component implements="coldbox.system.ioc.dsl.IDSLBuilder" extends="DslSpec" accessors="true"{

	/**
	* Constructor as per interface
	*/
	public any function init( required any injector ){
		return super.init( argumentCollection=arguments );
	}

	/**
	* Process an incoming DSL definition and produce an object with it.
	*/
	public any function process( required definition, targetObject ){
		return super.process( argumentCollection=arguments );
	}

}
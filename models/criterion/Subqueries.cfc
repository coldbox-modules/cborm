/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * A proxy to hibernate org.hibernate.criterion.Subqueries object to allow for criteria based subquerying
 * This object is a transient as detached criterias work without a hibernate session. Thus, you have
 * to pass in the detached criteria object we will be working with.
 *
 * @see https://docs.jboss.org/hibernate/stable/orm/javadocs/org/hibernate/criterion/Subqueries.html
 * @see https://docs.jboss.org/hibernate/stable/orm/javadocs/org/hibernate/criterion/DetachedCriteria.html
 */
component
	extends  ="cborm.models.criterion.Restrictions"
	accessors="true"
	scope    ="noscope"
{

	/**
	 * The detached criteria we are binding the subquery to
	 */
	property name="detachedCriteria";

	/**
	 * Constructor
	 *
	 * @javaProxy.inject JavaProxyBuilder@cborm
	 * @detachedCriteria Optional detached criteria object to bind this transient with
	 */
	Subqueries function init( required javaProxy, detachedCriteria ){
		variables.subqueries = arguments.javaProxy.build( "org.hibernate.criterion.Subqueries" );
		super.init( argumentCollection = arguments );

		if ( !isNull( arguments.detachedCriteria ) ) {
			variables.detachedCriteria = arguments.detachedCriteria;
		}

		return this;
	}

	/**
	 * Get the Java native class
	 *
	 * @return org.hibernate.criterion.Subqueries
	 */
	any function getNativeClass(){
		return variables.subqueries;
	}

	any function subEq( required any value ){
		return variables.subqueries.eq( arguments.value, variables.detachedCriteria );
	}

	any function subEqAll( required any value ){
		return variables.subqueries.eqAll( arguments.value, variables.detachedCriteria );
	}

	any function subGe( required any value ){
		return variables.subqueries.ge( arguments.value, variables.detachedCriteria );
	}

	any function subGeAll( required any value ){
		return variables.subqueries.geAll( arguments.value, variables.detachedCriteria );
	}

	any function subGeSome( required any value ){
		return variables.subqueries.geSome( arguments.value, variables.detachedCriteria );
	}

	any function subGt( required any value ){
		return variables.subqueries.gt( arguments.value, variables.detachedCriteria );
	}

	any function subGtAll( required any value ){
		return variables.subqueries.gtAll( arguments.value, variables.detachedCriteria );
	}

	any function subGtSome( required any value ){
		return variables.subqueries.gtSome( arguments.value, variables.detachedCriteria );
	}

	any function subIn( required any value ){
		return variables.subqueries.in( arguments.value, variables.detachedCriteria );
	}

	any function subLe( required any value ){
		return variables.subqueries.le( arguments.value, variables.detachedCriteria );
	}

	any function subLeAll( required any value ){
		return variables.subqueries.leAll( arguments.value, variables.detachedCriteria );
	}

	any function subLeSome( required any value ){
		return variables.subqueries.leSome( arguments.value, variables.detachedCriteria );
	}

	any function subLt( required any value ){
		return variables.subqueries.lt( arguments.value, variables.detachedCriteria );
	}

	any function subLtAll( required any value ){
		return variables.subqueries.ltAll( arguments.value, variables.detachedCriteria );
	}

	any function subLtSome( required any value ){
		return variables.subqueries.ltSome( arguments.value, variables.detachedCriteria );
	}

	any function subNe( required any value ){
		return variables.subqueries.ne( arguments.value, variables.detachedCriteria );
	}

	any function subNotIn( required any value ){
		return variables.subqueries.notIn( arguments.value, variables.detachedCriteria );
	}
	// where subquery returns a result
	any function exists(){
		return variables.subqueries.exists( variables.detachedCriteria );
	}
	// where subquery returns no result
	any function notExists(){
		return variables.subqueries.notExists( variables.detachedCriteria );
	}

	any function propertyEq( required string property ){
		return variables.subqueries.propertyEq( arguments.property, variables.detachedCriteria );
	}

	any function propertyEqAll( required string property ){
		return variables.subqueries.propertyEqAll( arguments.property, variables.detachedCriteria );
	}

	any function propertyGe( required string property ){
		return variables.subqueries.propertyGe( arguments.property, variables.detachedCriteria );
	}

	any function propertyGeAll( required string property ){
		return variables.subqueries.propertyGeAll( arguments.property, variables.detachedCriteria );
	}

	any function propertyGeSome( required string property ){
		return variables.subqueries.propertyGeSome( arguments.property, variables.detachedCriteria );
	}

	any function propertyGt( required string property ){
		return variables.subqueries.propertyGt( arguments.property, variables.detachedCriteria );
	}

	any function propertyGtAll( required string property ){
		return variables.subqueries.propertyGtAll( arguments.property, variables.detachedCriteria );
	}

	any function propertyGtSome( required string property ){
		return variables.subqueries.propertyGtSome( arguments.property, variables.detachedCriteria );
	}

	any function propertyIn( required string property ){
		return variables.subqueries.propertyIn( arguments.property, variables.detachedCriteria );
	}

	any function propertyLe( required string property ){
		return variables.subqueries.propertyLe( arguments.property, variables.detachedCriteria );
	}

	any function propertyLeAll( required string property ){
		return variables.subqueries.propertyLeAll( arguments.property, variables.detachedCriteria );
	}

	any function propertyLeSome( required string property ){
		return variables.subqueries.propertyLeSome( arguments.property, variables.detachedCriteria );
	}

	any function propertyLt( required string property ){
		return variables.subqueries.propertyLt( arguments.property, variables.detachedCriteria );
	}

	any function propertyLtAll( required string property ){
		return variables.subqueries.propertyLtAll( arguments.property, variables.detachedCriteria );
	}

	any function propertyLtSome( required string property ){
		return variables.subqueries.propertyLtSome( arguments.property, variables.detachedCriteria );
	}

	any function propertyNe( required string property ){
		return variables.subqueries.propertyNe( arguments.property, variables.detachedCriteria );
	}

	any function propertyNotIn( required string property ){
		return variables.subqueries.propertyNotIn( arguments.property, variables.detachedCriteria );
	}

}

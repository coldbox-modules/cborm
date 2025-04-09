/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 *
 * The BoxLang based ORM utility support
 *
 * @author Luis Majano
 */
component
	implements="IORMUtil"
	extends   ="ORMUtilSupport"
	singleton
{

	/**
	 * Get the Hibernate version
	 */
	public string function getHibernateVersion(){
		return ORMGetHibernateVersion();
	}

}

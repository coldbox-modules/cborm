/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 *
 * The Adobe based ORM utility support
 *
 * @author Luis Majano & Mike McKellip
 */
component
	implements="IORMUtil"
	extends   ="ORMUtilSupport"
	singleton
{

	/**
	 * Cross-engine transaction detection.
	 * Useful for preventing nested transactions.
	 *
	 * @see https://dev.lucee.org/t/determine-if-code-is-inside-cftransaction/7358
	 */
	public boolean function isInTransaction(){
		var transactionObj = createObject( "java", "coldfusion.tagext.sql.TransactionTag" );
		return !isNull( transactionObj.getCurrent() );
	}

	/**
	 * Get the hibernate session
	 *
	 * @datasource Optional datsource
	 *
	 * @return org.hibernate.Session
	 */
	any function getSession( string datasource ){
		if ( !isNull( arguments.datasource ) ) {
			// get actual session from coldfusion.orm.hibernate.SessionWrapper
			return ormGetSession( arguments.datasource ).getActualSession();
		} else {
			// get actual session from coldfusion.orm.hibernate.SessionWrapper
			return ormGetSession().getActualSession();
		}
	}

	/**
	 * Get the Hibernate version
	 */
	public string function getHibernateVersion(){
		// Dumb Adobe proxy crap
		var version = createObject( "java", "org.hibernate.Version" );

		if ( version.getVersionString() != "[WORKING]" ) {
			return version.getVersionString();
		} else {
			return version
				.getClass()
				.getClassLoader()
				.getBundle()
				.getVersion()
				.toString();
		}
	}

}

/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * @author Luis Majano & Mike McKellip
 *
 * Lucee Based ORM Utility
 */
component extends="cborm.models.util.ORMUtilSupport" implements="cborm.models.util.IORMUtil" {

	/**
	 * Get hibernate session object
	 *
	 * @datasource optional datasource
	 *
	 * @override
	 */
	any function getSession( string datasource ){
		return ( !isNull( arguments.datasource ) ? ORMGetSession( arguments.datasource ) : ORMGetSession() );
	}

}
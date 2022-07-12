/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 *
 * Lucee Based ORM Utility
 *
 * @author Luis Majano & Mike McKellip
 */
component extends="cborm.models.util.ORMUtilSupport" implements="cborm.models.util.IORMUtil" {

	/**
	 * Get hibernate session object
	 *
	 * @datasource optional datasource
	 * @override  
	 */
	any function getSession( string datasource ){
		return ( !isNull( arguments.datasource ) ? ormGetSession( arguments.datasource ) : ormGetSession() );
	}

	/**
	 * Retrieve the entity mode in effect for this session.
	 *
	 * @ormSession Pass the hibernate ORM session
	 *
	 * @return https://docs.jboss.org/hibernate/orm/5.4/javadocs/org/hibernate/EntityMode.html
	 */
	any function getSessionEntityMode( required ormSession, required entity ){
		if ( listFirst( getHibernateVersion(), "." ) >= 5 ) {
			return arguments.ormSession
				.getEntityPersister( arguments.ormSession.getEntityName( arguments.entity ), arguments.entity )
				.getEntityMode();
		} else {
			return arguments.ormSession.getEntityMode();
		}
	}

}

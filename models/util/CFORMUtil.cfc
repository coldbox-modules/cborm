/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 *
 * Adobe CF Based ORM Utility
 *
 * @author Luis Majano & Mike McKellip
 */
component implements="cborm.models.util.IORMUtil" extends="cborm.models.util.ORMUtilSupport" {

	/**
	 * Retrieve the entity mode in effect for this session.
	 *
	 * @ormSession Pass the hibernate ORM session
	 *
	 * @return https://docs.jboss.org/hibernate/core/3.5/javadocs/org/hibernate/EntityMode.html
	 */
	any function getSessionEntityMode( required ormSession, required entity ){
		return arguments.ormSession
			.getEntityPersister( arguments.ormSession.getEntityName( arguments.entity ), arguments.entity )
			.getEntityMode();
	}

}

/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 *
 * An agnostic Engine utility class for working with Hibernate ORM.
 *
 * @author Luis Majano & Mike McKellip
 */
component singleton {

	/**
	 * Sets up Hibernate logging levels and redirects logs to system out.
	 * 
	 * @deprecated Do not use anymore, the engine will provide this, this will be removed on v5
	 *
	 * @level The logging level to set in hibernate: ALL, DEBUG, INFO, WARN, ERROR, FATAL, OFF, TRACE
	 */
	void function setupHibernateLogging( level = "WARN" ){
		/**
		 * Resolves Hibernate ConcurrentModificationException when flushing an entity save with one-to-many relationships.
		 *
		 * @see https://access.redhat.com/solutions/29774
		 * @see https://michaelborn.me/entry/resolving-concurrent-exceptions-in-hibernate-logger
		 */
		var Logger       = createObject( "java", "org.apache.log4j.Logger" );
		var log4jLevel   = createObject( "java", "org.apache.log4j.Level" );
		var hibernateLog = Logger.getLogger( "org.hibernate" );
		hibernateLog.setLevel( log4jLevel[ arguments.level ] );
	}

	/**
	 * Flush a datasource
	 *
	 * @datasource Optional datsource
	 */
	void function flush( string datasource ){
		if ( !isNull( arguments.datasource ) ) {
			ormFlush( arguments.datasource );
		} else {
			ormFlush();
		}
	}

	/**
	 * Get the Hibernate session object
	 *
	 * @see https://docs.jboss.org/hibernate/orm/5.6/javadocs/org/hibernate/Session.html
	 * 
	 * @datasource optional datasource
	 * 
	 * 
	 * @return org.hibernate.Session
	 */
	any function getSession( string datasource ){
		return ( !isNull( arguments.datasource ) ? ormGetSession( arguments.datasource ) : ormGetSession() );
	}

	/**
	 * Get session factory
	 * 
	 * @see https://docs.jboss.org/hibernate/orm/5.6/javadocs/org/hibernate/SessionFactory.html
	 *
	 * @datasource Optional datsource
	 * 
	 * @return org.hibernate.SessionFactory
	 */
	any function getSessionFactory( string datasource ){
		if ( !isNull( arguments.datasource ) ) {
			return ormGetSessionFactory( arguments.datasource );
		} else {
			return ormGetSessionFactory();
		}
	}

	/**
	 * Clear a session
	 *
	 * @datasource Optional datsource
	 */
	void function clearSession( string datasource ){
		if ( !isNull( arguments.datasource ) ) {
			ormClearSession( arguments.datasource );
		} else {
			ormClearSession();
		}
	}

	/**
	 * Close a session
	 *
	 * @datasource Optional datsource
	 */
	void function closeSession( string datasource ){
		if ( !isNull( arguments.datasource ) ) {
			ormCloseSession( arguments.datasource );
		} else {
			ormCloseSession();
		}
	}

	/**
	 * Evict queries
	 *
	 * @cacheName  The optional cache name
	 * @datasource Optional datsource
	 */
	void function evictQueries( string cachename, string datasource ){
		if ( !isNull( arguments.cacheName ) AND !isNull( arguments.datasource ) ) {
			ormEvictQueries( arguments.cachename, arguments.datasource );
		} else if ( !isNull( arguments.cacheName ) ) {
			ormEvictQueries( arguments.cachename );
		} else {
			ormEvictQueries();
		}
	}

	/**
	 * Returns the datasource for a given entity
	 *
	 * @entity            The entity reference. Can be passed as an object or as the entity name.
	 * @defaultDatasource The default datasource to use if not, do self-discovery
	 * 
	 * @return The entity datasource
	 */
	string function getEntityDatasource( required entity, string defaultDatasource ){
		// DEFAULT datasource
		var datasource = (
			isNull( arguments.defaultDatasource ) ? getDefaultDatasource() : arguments.defaultDatasource
		);

		if ( !isObject( arguments.entity ) ) {
			arguments.entity = entityNew( arguments.entity );
		}

		var md = getMetadata( arguments.entity );
		if ( structKeyExists( md, "datasource" ) ) {
			datasource = md.datasource;
		}

		return datasource;
	}

	/**
	 * Get the default application datasource
	 * 
	 * @return Default application datasource
	 */
	string function getDefaultDatasource(){
		// get application metadata
		var settings = getApplicationMetadata();

		// check orm settings first
		if ( structKeyExists( settings, "ormsettings" ) AND structKeyExists( settings.ormsettings, "datasource" ) ) {
			return settings.ormsettings.datasource;
		}

		// else default to app datasource
		return settings.datasource;
	}


	/**
	 * Get an entity's metadata from hibernate
	 *
	 * @see        https://docs.jboss.org/hibernate/orm/5.6/javadocs/org/hibernate/SessionFactory.html
	 * @see        https://docs.jboss.org/hibernate/orm/5.6/javadocs/org/hibernate/metadata/ClassMetadata.html
	 * 
	 * @todo This method is deprecated in Hibernate: Use the descriptors from EntityManagerFactory.getMetamodel() instead

	 * 
	 * @entityName The entity name
	 * @datasource The datasource string to use for the lookup
	 *
	 * @return org.hibernate.metadata.ClassMetadata
	 */
	any function getEntityMetadata( required string entityName, required string datasource ){
		return getSessionFactory( arguments.datasource ).getClassMetaData( arguments.entityName );
	}

	/**
	 * Get the Hibernate version
	 */
	public string function getHibernateVersion(){
		return createObject( "java", "org.hibernate.Version" ).getVersionString();
	}

	/**
	 * Retrieve the entity mode in effect for this session.
	 * 
	 * @see https://docs.jboss.org/hibernate/orm/5.6/javadocs/org/hibernate/EntityMode.html
	 * 
	 * @ormSession Pass the hibernate ORM session
	 * 
	 * @return org.hibernate.EntityMode
	 */
	any function getSessionEntityMode( required ormSession, required entity ){
		return arguments.ormSession
			.getEntityPersister( arguments.ormSession.getEntityName( arguments.entity ), arguments.entity )
			.getEntityMode();
	}

	/**
	 * Returns the entity name from a given entity object via session lookup or if new object via metadata lookup
	 *
	 * @entity The entity to get it's name from
	 *
	 * @return The entity name
	 */
	function getEntityGivenName( required entity ){
		// Short-cut discovery via ActiveEntity
		if ( structKeyExists( arguments.entity, "getEntityName" ) ) {
			return arguments.entity.getEntityName();
		}

		// Hibernate Discovery
		try {
			var entityName = getSession( getEntityDatasource( arguments.entity ) ).getEntityName(
				arguments.entity
			);
		} catch ( org.hibernate.TransientObjectException e ) {
			// ignore it, it is not in session, go for long-discovery
		}

		// Long Discovery
		var md = getMetadata( arguments.entity );
		return ( md.keyExists( "entityName" ) ? md.entityName : listLast( md.name, "." ) );
	}

	/**
	 * Cross-engine transaction detection.
	 * Useful for preventing nested transactions.
	 */
	public boolean function isInTransaction(){
		return isWithinTransaction();
	}

}

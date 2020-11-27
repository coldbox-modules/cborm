/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 * @author Luis Majano & Mike McKellip
 *
 * An agnostic CFML Engine utility class
 */
component {

	/**
	 * Flush a datasource
	 *
	 * @datasource Optional datsource
	 */
	void function flush( string datasource ) {
		if ( !isNull( arguments.datasource ) ) {
			ormFlush( arguments.datasource );
		} else {
			ormFlush();
		}
	}

	/**
	 * Get session
	 *
	 * @datasource Optional datsource
	 */
	any function getSession( string datasource ) {
		if ( !isNull( arguments.datasource ) ) {
			// get actual session from coldfusion.orm.hibernate.SessionWrapper
			return ormGetSession( arguments.datasource ).getActualSession();
		} else {
			// get actual session from coldfusion.orm.hibernate.SessionWrapper
			return ormGetSession().getActualSession();
		}
	}

	/**
	 * Get session factory
	 *
	 * @datasource Optional datsource
	 */
	any function getSessionFactory( string datasource ) {
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
	void function clearSession( string datasource ) {
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
	void function closeSession( string datasource ) {
		if ( !isNull( arguments.datasource ) ) {
			ormCloseSession( arguments.datasource );
		} else {
			ormCloseSession();
		}
	}

	/**
	 * Evict queries
	 *
	 * @cacheName The optional cache name
	 * @datasource Optional datsource
	 */
	void function evictQueries( string cachename, string datasource ) {
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
	 * @entity The entity reference. Can be passed as an object or as the entity name.
	 * @defaultDatasource The default datasource to use if not, do self-discovery
	 */
	string function getEntityDatasource( required entity, string defaultDatasource ) {
		// DEFAULT datasource
		var datasource = ( isNull( arguments.defaultDatasource ) ? getDefaultDatasource() : arguments.defaultDatasource );

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
	 */
	string function getDefaultDatasource() {
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
	 * @see https://docs.jboss.org/hibernate/orm/3.5/javadocs/org/hibernate/SessionFactory.html
	 *
	 * @entityName The entity name
	 * @datasource The datasource string to use for the lookup
	 *
	 * @return org.hibernate.metadata.ClassMetadata
	 */
	any function getEntityMetadata( required string entityName, required string datasource ) {
		return getSessionFactory( arguments.datasource ).getClassMetaData( arguments.entityName );
	}

}

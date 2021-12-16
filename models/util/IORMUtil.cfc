/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 *
 * This interface is used so each CFML engine can implement its interface into Hibernate.
 */
interface {

	void function flush( string datasource );
	any function getSession( string datasource );
	any function getSessionFactory( string datasource );
	void function clearSession( string datasource );
	void function closeSession( string datasource );
	void function evictQueries( string cachename, string datasource );
	string function getEntityDatasource( required entity, string defaultDatasource );
	string function getDefaultDatasource();
	any function getEntityMetadata( required string entityName, required string datasource );
	any function getSessionEntityMode( required ormSession, required entity );

}

/**
* Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
* www.ortussolutions.com
* ********************************************************************************
* Author      :	Luis Majano & Mike McKellip
* Description :
*
* The base interface for retreieveing the right CF ORM session for CFML engines
* that do not support multiple dsn's yet.
*
* Once they do, these implementations will disappear.
*/
interface {

	void	function flush( string datasource );
	any  	function getSession( string datasource );
	any  	function getSessionFactory( string datasource );
	void 	function clearSession( string datasource );
	void 	function closeSession( string datasource );
	void 	function evictQueries( string cachename, string datasource );
	string	function getEntityDatasource( required entity, string defaultDatasource );
	string	function getDefaultDatasource();
	any 	function getEntityMetadata( required string entityName, required string datasource );

}
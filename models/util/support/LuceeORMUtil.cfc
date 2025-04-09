/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 *
 * Lucee Based ORM Utility
 *
 * @author Luis Majano & Mike McKellip
 */
component implements="IORMUtil" extends="ORMUtilSupport" singleton{

	/**
	 * Sets up Hibernate logging levels and redirects logs to system out.
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

		/**
		 * Redirect all Hibernate logs to system.out
		 */
		var printWriter     = getPageContext().getConfig().getOutWriter();
		var layout          = createObject( "java", "lucee.commons.io.log.log4j.layout.ClassicLayout" );
		var consoleAppender = createObject( "java", "lucee.commons.io.log.log4j.appender.ConsoleAppender" ).init(
			printWriter,
			layout
		);
		hibernateLog.addAppender( consoleAppender );
		writeDump( var = "** Lucee Hibernate Logging Redirected", output = "console" );
	}

}

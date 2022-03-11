/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 *
 * This builder will create the java proxies, cache them, and then use them by the caller.
 *
 * @author Luis Majano
 */
component singleton {

	/**
	 * Constructor
	 */
	function init(){
		variables.javaProxies = createObject( "java", "java.util.concurrent.ConcurrentHashMap" ).init();
		return this;
	}

	/**
	 * Build and return the java proxy
	 */
	function build( required type ){
		if ( !variables.javaProxies.containsKey( arguments.type ) ) {
			variables.javaProxies.put(
				arguments.type,
				{
					type   : arguments.type,
					object : createObject( "java", arguments.type )
				}
			);
		}
		return variables.javaProxies.get( arguments.type ).object;
	}

}

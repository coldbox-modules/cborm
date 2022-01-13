/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 *
 * A simple factory to return the right ORM utility according to CFML engine
 *
 * @author Luis Majano & Mike McKellip
 */
import cborm.models.util.*;

component {

	/**
	 * Get the ORM Utility object
	 *
	 * @return IORMUtil
	 */
	function getORMUtil(){
		// Adobe ColdFusion
		if ( getPlatform() == "ColdFusion Server" ) {
			return new CFORMUtil();
		}

		// Lucee Support
		return new LuceeORMUtil();
	}

	/**
	 * Get platform name
	 */
	private string function getPlatform(){
		return server.coldfusion.productname;
	}

	/**
	 * Get lucee version
	 */
	private string function getLuceeVersion(){
		return server.lucee.version;
	}

}

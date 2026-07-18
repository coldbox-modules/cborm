/**
 * Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
 * www.ortussolutions.com
 * ---
 *
 * A simple factory to return the right ORM utility according to CFML engine
 *
 * @author Luis Majano & Mike McKellip
 */
import cborm.models.util.support.*;

component {

	this.isBoxLang = server.keyExists( "boxlang" );
	this.isAdobe   = server.keyExists( "coldfusion" ) && server.coldfusion.productname == "ColdFusion Server";

	/**
	 * Get the ORM Utility object
	 *
	 * @return IORMUtil
	 */
	function getORMUtil(){
		if ( this.isAdobe ) {
			return new AdobeORMUtil()
		} else {
			return new BoxLangORMUtil()
		}
	}

	/**
	 * Get platform name
	 */
	private string function getPlatform(){
		return server.coldfusion.productname;
	}

}

component extends = "coldbox.system.ioc.config.Binder"{
	/**
	 * Configure WireBox, that's it!
	 */
	function configure(){
		// WireBox Mappings
		map( "WireBoxURL" ).toValue( "TEST" );
		map( "testService" ).to( "root.models.TestService" );
	}
}

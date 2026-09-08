component {

	moduleRoot = createObject( "java", "java.io.File" )
		.init( getDirectoryFromPath( getCurrentTemplatePath() ) & "../../../" )
		.getCanonicalPath();

	this.name                    = "cborm-full-null-regression-#hash( moduleRoot )#";
	this.enableNullSupport       = true;
	this.mappings[ "/cborm" ]    = moduleRoot;
	this.mappings[ "/coldbox" ]  = moduleRoot & "/test-harness/coldbox";
	this.mappings[ "/fullnull" ] = getDirectoryFromPath( getCurrentTemplatePath() );

}

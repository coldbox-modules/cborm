<cfsetting showDebugOutput="false">
<cfscript>
wirebox             = new fullnull.FakeWireBox();
application.wirebox = wirebox;
service             = new cborm.models.BaseORMService( datasource = "unused" );

orm          = service.getOrm();
sameOrm      = service.getOrm();
eventHandler = service.getORMEventHandler();
sameHandler  = service.getORMEventHandler();

dynamicProcessor     = service.getDynamicProcessor();
sameDynamicProcessor = service.getDynamicProcessor();
objectPopulator      = service.getObjectPopulator();
sameObjectPopulator  = service.getObjectPopulator();
callCounts           = wirebox.getCallCounts();
system               = createObject( "java", "java.lang.System" );

if (
	!isInstanceOf( orm, "cborm.models.util.support.AdobeORMUtil" ) ||
	!isInstanceOf( sameOrm, "cborm.models.util.support.AdobeORMUtil" ) ||
	system.identityHashCode( orm ) != system.identityHashCode( sameOrm ) ||
	!isInstanceOf( eventHandler, "cborm.models.EventHandler" ) ||
	!isInstanceOf( sameHandler, "cborm.models.EventHandler" ) ||
	system.identityHashCode( eventHandler ) != system.identityHashCode( sameHandler ) ||
	!isStruct( dynamicProcessor ) ||
	!isStruct( sameDynamicProcessor ) ||
	!isStruct( objectPopulator ) ||
	!isStruct( sameObjectPopulator ) ||
	callCounts.instance != 1 ||
	callCounts.objectPopulator != 1
) {
	throw( type = "RegressionFailure", message = "cbORM public lazy dependencies did not initialize exactly once." );
}

writeOutput( "PASS" );
</cfscript>

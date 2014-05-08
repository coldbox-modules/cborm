component extends="coldbox.system.testing.BaseTestCase"{
	this.loadColdBox = false;
	function setup(){
		factory   = getMockBox().createMock("cborm.model.util.ORMUtilFactory");
	}
	
	function testAdobe(){
		factory.$("getPlatform","ColdFusion Server");
		u = factory.getORMUtil();
		assertEquals('cborm.model.util.CFORMUtil', getMetadata(u).name );
	}
	
	function testOther(){
		factory.$("getPlatform","Railo");
		u = factory.getORMUtil();
		assertEquals('cborm.model.util.ORMUtil', getMetadata(u).name );
	}
}
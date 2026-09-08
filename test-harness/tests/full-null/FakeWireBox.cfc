component {

	variables.instanceCalls        = 0;
	variables.objectPopulatorCalls = 0;
	variables.dynamicProcessor     = { type : "dynamicProcessor" };
	variables.objectPopulator      = { type : "objectPopulator" };

	function getInstance(){
		variables.instanceCalls++;
		return variables.dynamicProcessor;
	}

	function getLogBox(){
		return this;
	}

	function getLogger(){
		return {};
	}

	function getObjectPopulator(){
		variables.objectPopulatorCalls++;
		return variables.objectPopulator;
	}

	function getCallCounts(){
		return {
			instance        : variables.instanceCalls,
			objectPopulator : variables.objectPopulatorCalls
		};
	}

}

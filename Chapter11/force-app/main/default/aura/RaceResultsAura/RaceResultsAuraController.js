({
    /**
     * Loads the race results for the race on screen as specified via recordId via the x interface
     **/
    onInit : function(component, event, helper) {

        // If we have a recordId context load the race results
        var recordId = component.get('v.recordId');
        if(recordId!=null) {
            helper.getRaceResults(component, event);
        }
    },
    /**
     * Loads the race results for the race specified in the event
     **/
	handleRaceSelectedEvent : function(component, event, helper) {
	
	    // Update race record Id and Name attributes from Event parameters
		component.set('v.recordId', event.getParam('raceId'));
		component.set('v.recordName', event.getParam('raceName'));

		// Retrieve race results
		helper.getRaceResults(component, event);
	}
})
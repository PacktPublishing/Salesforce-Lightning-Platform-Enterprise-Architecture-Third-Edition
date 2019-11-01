({
    /**
     * Loads the race results based on contents of v.recordId
     **/
	getRaceResults : function(component, event ) {
	    var raceId = component.get('v.recordId');
        var action = component.get("c.getRaceResults");
        action.setParam('raceId', raceId);
        action.setCallback(this, function(response) {
                if(response.getState() === 'SUCCESS') {
                    component.set("v.results", response.getReturnValue());
                }                
            });
        $A.enqueueAction(action);        	    
	}
})
({
    /**
     * Calls Apex Controller method to load Race Standings sets 'standings' attribute
     **/
    getStandings : function(component, event ) {
        var action = component.get("c.getStandings");
        action.setCallback(this, function(response) {
                if(response.getState() === 'SUCCESS') {
                    component.set("v.standings", response.getReturnValue());
                }                
            });
        $A.enqueueAction(action);        
    }
})
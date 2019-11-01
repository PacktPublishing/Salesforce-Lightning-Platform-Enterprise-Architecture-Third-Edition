({
    /**
     * Calls Apex Controller method to load Drivers sets 'driver' attribute
     **/
    getDrivers : function(component, event ) {
        var action = component.get("c.getDriverList");
        action.setCallback(this, function(response) {
                if(response.getState() === 'SUCCESS') {
                    component.set("v.drivers", response.getReturnValue());
                }                
            });
        $A.enqueueAction(action);        
    },
    /**
     * Calls the Apex Controller to pass back the drivers list, adding those selected, closes popup on success
     **/
    addDrivers : function(component, event ) {
        var action = component.get("c.addDrivers");
        action.setParam('raceId', component.get('v.recordId'));
        action.setParam('driversToAdd', component.get('v.drivers')); // For more optimal requests we would just sent the selected Id's
        action.setCallback(this, function(response) {
                if(response.getState() === 'SUCCESS') {
                    // Refresh the view to show the recently added drivers
                    $A.get('e.force:refreshView').fire();
                    // Display Toast message to confirm drivers                    
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Add Drivers",
                        "message": "Added " + response.getReturnValue() + " drivers."
                    });
                    resultsToast.fire();            
                    // Close the action panel
                    $A.get("e.force:closeQuickAction").fire();
                }                
            });
        $A.enqueueAction(action);    
    }
})
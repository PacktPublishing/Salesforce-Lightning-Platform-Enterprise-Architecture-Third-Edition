({
    /**
     * Loads the available drivers
     **/
    onInit : function(component, event, helper) {
        helper.getDrivers(component, event);
    },
    /**
     * Passes the selected drivers back to the Apex controller, if successful closes action popup
     **/
    onAddDrivers : function(component, event, helper) {
        helper.addDrivers(component, event);
    },
    /**
     * Close the action panel
     **/
    onCancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }    
})
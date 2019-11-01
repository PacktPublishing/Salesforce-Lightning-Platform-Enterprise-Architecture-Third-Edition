({
    handleClose : function(component, event, helper) {
        // Close the quick action popup
        $A.get("e.force:closeQuickAction").fire();
    },
    handleAdded : function(component, event, helper) {
        // Refresh the view to show the recently added drivers
        $A.get('e.force:refreshView').fire();
        // Close the quick action popup
        $A.get("e.force:closeQuickAction").fire();
    }    
})
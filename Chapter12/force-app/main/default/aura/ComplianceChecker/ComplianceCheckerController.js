({
	onInit : function(component, event, helper) {
	    helper.verifyCompliance(component, event);
	},
    onRefreshView : function(component, event, helper) {
        helper.verifyCompliance(component, event);
    }
})
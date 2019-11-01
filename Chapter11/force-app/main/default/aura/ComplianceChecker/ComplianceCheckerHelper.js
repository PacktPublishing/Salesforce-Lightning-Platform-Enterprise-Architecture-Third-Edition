({
	verifyCompliance : function(component) {
        var action = component.get("c.verify");
        action.setParams({ "recordId" : component.get("v.recordId") });
        action.setCallback(this, function(response) {
                if(response.getState() === 'SUCCESS') {
                    var messages = response.getReturnValue();
                    if(messages!=null) {
                        component.set("v.category", "error");
                        component.set("v.messages", messages);
                    } else {
                        component.set("v.category", "success");
                        component.set("v.messages", [ "Verified compliance" ]);
                    }
                }                
            });
        $A.enqueueAction(action);        
	}
})
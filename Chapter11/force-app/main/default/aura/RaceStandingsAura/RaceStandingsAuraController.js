({
    /**
     * Loads the race standings from the server
     **/
    onInit : function(component, event, helper) {
        helper.getStandings(component, event);
    }
})
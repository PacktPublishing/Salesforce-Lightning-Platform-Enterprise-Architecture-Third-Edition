({
    /**
     * Loads the race calendar from the server
     **/
    onInit : function(component, event, helper) {
        helper.getCalendar(component, event);
    },
    /**
     * Updates the selected race to the one clicked and fires the RaceSelected application event
     **/
    onRaceClicked : function(component, event, helper) {
        helper.selectRace(component, event);
    }
})
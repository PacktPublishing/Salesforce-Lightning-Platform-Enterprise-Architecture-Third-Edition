({
    /**
     * Calls Apex Controller method to load Race Calendar sets 'calendar' attribute
     **/
    getCalendar : function(component, event ) {
        var action = component.get("c.getRaceCalendar");
        action.setCallback(this, function(response) {
                if(response.getState() === 'SUCCESS') {
                    component.set("v.calendar", response.getReturnValue());
                }                
            });
        $A.enqueueAction(action);        
    },
    /**
     * Updates the selected race to the one clicked and fires the RaceSelected application event
     **/
    selectRace : function(component, event ) {    
        // Establish the selected race via the HTML5 data attribute raceid added in the markup
        var selectedRaceId = event.currentTarget.dataset.raceid;
        var selectedRaceName = event.currentTarget.dataset.racename;
        
        // Mark the race as selected and deselect any currently selected
        var calendar = component.get('v.calendar');
        this.updateSelectedRace(calendar.Remaining, selectedRaceId);
        this.updateSelectedRace(calendar.Completed, selectedRaceId);
        component.set("v.calendar", calendar);
        
        // Fire the RaceSelected event
        var compEvent = $A.get("e.c:RaceSelectedAura");
        compEvent.setParams({"raceId" : selectedRaceId } );
        compEvent.setParams({"raceName" : selectedRaceName } );
        compEvent.fire();        
    },
    /**
     * Utility function scans a list of races and marks the given race as selected
     **/
    updateSelectedRace : function(races, raceId) {
        for(var raceIdx = 0; raceIdx < races.length; raceIdx++) {
            races[raceIdx].Selected = races[raceIdx].Id == raceId ? true : false;
        }
    }    
})
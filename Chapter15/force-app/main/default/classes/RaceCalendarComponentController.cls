public with sharing class RaceCalendarComponentController {

    /**
     * Server side controller method for the RaceCalendar Lightning Component
     **/
    @AuraEnabled(cacheable=true)
    public static List<RaceCalendarItem> getRaceCalendar() {
                
        List<RaceCalendarItem> completedRaces = new List<RaceCalendarItem>();
        List<RaceCalendarItem> remainingRaces = new List<RaceCalendarItem>();
        Integer numberOfCompletedRaces = 17; // Hard coded for sample code in this chapter
        Integer raceIdx = 0;
        for(Race__c race : new RacesSelector().selectAllForCurrentYear()) {
            RaceCalendarItem raceCalendarItem = new RaceCalendarItem();
            raceCalendarItem.Id = race.Id;
            raceCalendarItem.Name = race.Name;
            raceCalendarItem.Location = race.Location__c;
            raceCalendarItem.RaceDate = race.StartDate__c.format() + ' - ' + race.EndDate__c.format();
            raceCalendarItem.Selected = false;
            raceIdx++;
            if(raceIdx < numberOfCompletedRaces) {
                raceCalendarItem.Completed = true;
                completedRaces.add(raceCalendarItem);
            } else {
                raceCalendarItem.Completed = false;
                if(remainingRaces.size()>0) {
                    remainingRaces.add(0, raceCalendarItem); 
                } else {
                    remainingRaces.add(raceCalendarItem);
                }                
            }
        }
        List<RaceCalendarItem> allRaces = new List<RaceCalendarItem>();
        allRaces.addAll(remainingRaces);
        allRaces.addAll(completedRaces);
        return allRaces;
    }

    public class RaceCalendarItem {
        @AuraEnabled
        public Boolean Selected;
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String Location;
        @AuraEnabled
        public String RaceDate;
        @AuraEnabled
        public Boolean Completed;            
    }    
}
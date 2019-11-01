public with sharing class RaceCalendarAuraComponentController {

    /**
     * Server side controller method for the RaceCalendar Lightning Component
     **/
    @AuraEnabled
    public static RaceCalendar getRaceCalendar() {
                
        RaceCalendar calendar = new RaceCalendar();
        calendar.Remaining = new List<RaceCalendarItem>();
        calendar.Completed = new List<RaceCalendarItem>();
        for(Race__c race : new RacesSelector().selectAllForCurrentYear()) {
            RaceCalendarItem raceCalendarItem = new RaceCalendarItem();
            raceCalendarItem.Id = race.Id;
            raceCalendarItem.Name = race.Name;
            raceCalendarItem.Location = race.Location__c;
            raceCalendarItem.RaceDate = race.StartDate__c.format() + ' - ' + race.EndDate__c.format();
            raceCalendarItem.Selected = false;
            if(race.StartDate__c < System.today()) {
                calendar.Completed.add(raceCalendarItem);
            } else {
                if(calendar.Remaining.size()>0) {
                    calendar.Remaining.add(0, raceCalendarItem); 
                } else {
                    calendar.Remaining.add(raceCalendarItem);
                }                
            }
        }
        if(calendar.Remaining.size()>0) {
            calendar.Remaining[0].Selected = true;
        }
        return calendar;
    }
    
    public class RaceCalendar {
        @AuraEnabled
        public List<RaceCalendarItem> Remaining;
        @AuraEnabled
        public List<RaceCalendarItem> Completed;
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
    }    
}
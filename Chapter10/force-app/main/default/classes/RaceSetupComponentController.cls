public with sharing class RaceSetupComponentController {
 
    @AuraEnabled(cacheable=true)
    public static List<DriverSelection> getDriverList() {
        try {
            List<DriverSelection> drivers = new List<DriverSelection>();
            for(Driver__c driver : new DriversSelector().selectAll()) {
                DriverSelection driverSelection = new DriverSelection();
                driverSelection.RecordId = driver.Id;
                driverSelection.Name = driver.Name;
                driverSelection.Selected = false;
                drivers.add(driverSelection);            
            }
            return drivers;
        } catch (Exception e) {
            Application.throwAuraHandledException(e);
        }
        return null;
    }

    @AuraEnabled
    public static Integer addDrivers(Id raceId, List<DriverSelection> driversToAdd) {
        try {
            Map<Id, List<Id>> driversByRaceId = new Map<Id, List<Id>>();
            List<Id> selectedDriverIds = new List<Id>();
            for(Integer driverIdx=0; driverIdx < driversToAdd.size(); driverIdx++) {
                DriverSelection driverSelection = driversToAdd[driverIdx];
                if(driverSelection.Selected) {
                    selectedDriverIds.add(driverSelection.RecordId);                
                }
            }
            driversByRaceId.put(raceId, selectedDriverIds);
            return RaceService.addDrivers(driversByRaceId).get(raceId);
        } catch (Exception e) {
            Application.throwAuraHandledException(e);
        }
        return null;
   }

    @AuraEnabled
    public static Integer addDriversLwc(Id raceId, List<Id> driversToAdd) {
        try {
            return RaceService.addDrivers(
                new Map<Id, List<id>>{ raceId => driversToAdd }).get(raceId);
        } catch (Exception e) {
            Application.throwAuraHandledException(e);
        }
        return null;
    }

    public class DriverSelection {
        @AuraEnabled
        public Id RecordId;
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public Boolean Selected;
    }   
}
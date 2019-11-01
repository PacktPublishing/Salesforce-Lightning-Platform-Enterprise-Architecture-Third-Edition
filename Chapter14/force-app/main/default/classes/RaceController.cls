public with sharing class RaceController {
    
	@AuraEnabled
    public static void awardPoints(Id raceId) {
    	try {
    		RaceService.awardChampionshipPoints(new Set<Id> { raceId });
    	}
    	catch (Exception e) {
    		Application.throwAuraHandledException(e);
    	}                
    }
}
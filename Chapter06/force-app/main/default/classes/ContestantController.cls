public with sharing class ContestantController {
    
    @AuraEnabled
    public static void awardPoints(Id contestantId) {
    	try {
        	ContestantService.awardChampionshipPoints(new Set<Id> { contestantId });
        }
        catch (Exception e) {
        	Application.throwAuraHandledException(e);
        }        
    }
}
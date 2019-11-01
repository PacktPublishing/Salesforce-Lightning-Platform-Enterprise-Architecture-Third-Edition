public with sharing class SeasonController {
    
    @AuraEnabled
    public static void sendNewsletter(Id seasonId) {
        try {
            SeasonService.issueNewsLetters(null);        
        } catch (Exception e) {
            Application.throwAuraHandledException(e);
        }
    }
}
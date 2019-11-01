public with sharing class ComplianceCheckerComponent {

    @AuraEnabled
    public static List<String> verify(Id recordId) {
        try {
            // Verify the given record for compliance
            ComplianceService.verify(new Set<Id> { recordId });
            // Success, all good!
            return null;
        } catch (Exception e) {
            // Report message as normal via apex:pageMessages
            List<String> messages = new List<String> { e.getMessage() };
            // Display additional compliance failure messages?
            if(e instanceof ComplianceService.ComplianceException) {
                ComplianceService.ComplianceException ce = (ComplianceService.ComplianceException) e;
                for(ComplianceService.VerifyResult verifyResult : ce.failures) {
                    messages.add( 
                        String.format('{0} ({1})', 
	                        new List<String> { 
	                            verifyResult.failureReason,
	                            verifyResult.complianceCode }));                   
                }
            }
            return messages;
        }                
    }
}
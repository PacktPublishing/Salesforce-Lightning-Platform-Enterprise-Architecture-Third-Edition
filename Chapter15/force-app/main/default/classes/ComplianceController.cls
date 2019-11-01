public with sharing class ComplianceController  {
    
	private ApexPages.StandardController standardController;

	public ComplianceController(ApexPages.StandardController standardController) {
		this.standardController = standardController;
	}

	public PageReference verify() {
		try {
			// Pass the record to the compliance service
			ComplianceService.verify(new Set<Id> { standardController.getId() });

			// Passed!
			ApexPages.addMessage(
				new ApexPages.Message(
					ApexPages.Severity.Info, 'Compliance passed'));
		} catch (Exception e) {
			// Report message as normal via apex:pageMessages
			ApexPages.addMessages(e);
			// Display additional compliance failure messages?
			if(e instanceof ComplianceService.ComplianceException) {
				ComplianceService.ComplianceException ce = (ComplianceService.ComplianceException) e;
				for(ComplianceService.VerifyResult verifyResult : ce.failures) {
                    ApexPages.addMessage(
                        new ApexPages.Message(
                            ApexPages.Severity.Error, 
                            String.format('{0} ({1})', 
                                new List<String> { 
                                    verifyResult.failureReason,
                                    verifyResult.complianceCode })));				    
				}
			}
		}
		return null;
	}
}
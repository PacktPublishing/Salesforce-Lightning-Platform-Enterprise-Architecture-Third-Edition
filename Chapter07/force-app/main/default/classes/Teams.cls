public inherited sharing class Teams extends ApplicationDomain implements ComplianceService.ICompliant {
    
	public Teams(List<Team__c> teams) {
		super(teams);
	}

	/**
	 * Checks the Team and related Driver records for compliance with the latest rules
	 **/
	public List<ComplianceService.VerifyResult> verifyCompliance() {
		// Verify Team compliance
		List<ComplianceService.VerifyResult> teamVerifyResults = 
			new List<ComplianceService.VerifyResult>();
		for(Team__c team : (List<Team__c>) Records) {
			// Check testing distance compliance
			ComplianceService.VerifyResult testingDistance = new ComplianceService.VerifyResult();
			testingDistance.ComplianceCode = '22.5';
			testingDistance.RecordId = team.Id;
			testingDistance.passed = team.TestingDistance__c!=null ? team.TestingDistance__c <= 15000 : true;
			testingDistance.failureReason = testingDistance.passed ? null : 'Testing exceeded 15,000km';
			teamVerifyResults.add(testingDistance);
		}

		// Verify associated Drivers compliance
		teamVerifyResults.addAll(
			new Drivers(
				new DriversSelector().selectByTeam(
					new Map<Id, SObject>(Records).keySet())).verifyCompliance());

		return teamVerifyResults;		
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Teams(sObjectList);
		}
	}		
}
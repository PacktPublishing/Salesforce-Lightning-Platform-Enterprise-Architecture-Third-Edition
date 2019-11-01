public inherited sharing class Cars extends ApplicationDomain implements ComplianceService.ICompliant {
    
	public Cars(List<Car__c> cars) {
		super(cars);
	}

	public List<ComplianceService.VerifyResult> verifyCompliance() {
		List<ComplianceService.VerifyResult> compliances = new List<ComplianceService.VerifyResult>();
		for(Car__c car : (List<Car__c>) Records) {
			// Check weight compliance
			ComplianceService.VerifyResult license = new ComplianceService.VerifyResult();
			license.ComplianceCode = '4.1';
			license.RecordId = car.Id;
			license.passed = car.Weight__c !=null && car.Weight__c >= 691;
			license.failureReason = license.passed ? null : 'Car must not be less than 691kg.';
			compliances.add(license);
		}
		return compliances;
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Cars(sObjectList);
		}
	}
}
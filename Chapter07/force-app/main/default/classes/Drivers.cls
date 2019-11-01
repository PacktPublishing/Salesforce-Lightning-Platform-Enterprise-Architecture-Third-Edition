public inherited sharing class Drivers extends ApplicationDomain implements ComplianceService.ICompliant {
    
	public Drivers(List<Driver__c> drivers) {
		super(drivers);
	}

	/**
	 * Applies defaults when creating new Driver records
	 **/
	public override void onApplyDefaults() {
		for(Driver__c driver : (List<Driver__c>) Records) {
			if(driver.ShortName__c == null) {
				// Upper case first three letters of drivers last name
				String lastName = driver.Name.substringAfterLast(' ');
				driver.ShortName__c = lastName.left(3).toUpperCase();
			}
		}
	}

	/**
	 * Checks the Driver records for compliance with the latest rules
	 **/
	public List<ComplianceService.VerifyResult> verifyCompliance() {
		List<ComplianceService.VerifyResult> compliances = new List<ComplianceService.VerifyResult>();
		for(Driver__c driver : (List<Driver__c>) Records) {
			// Check FIA Super License compliance
			ComplianceService.VerifyResult license = new ComplianceService.VerifyResult();
			license.ComplianceCode = '4.1';
			license.RecordId = driver.Id;
			license.passed = driver.FIASuperLicense__c;
			license.failureReason = license.passed ? null : 'Driver must have a FIA Super License.';
			compliances.add(license);
		}
		return compliances;		
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Drivers(sObjectList);
		}
	}	
}
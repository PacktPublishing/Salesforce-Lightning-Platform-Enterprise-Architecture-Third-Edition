@RestResource(urlMapping='/v1.0/compliance')
global with sharing class ComplianceResource_v1_0 
{
	global class VerifyResult
	{
		global Id recordId;
		global String complianceCode;
		global Boolean passed;
		global String failureReason;
	}		

	@HttpPost
	global static List<VerifyResult> report(List<Id> Ids)
	{
		List<VerifyResult> results = new List<VerifyResult>();
		for(ComplianceService.VerifyResult result : 
				ComplianceService.report(new Set<Id>(Ids)))
			results.add(makeVerifyResult(result));
		return results;
	}

	private static VerifyResult makeVerifyResult(ComplianceService.VerifyResult verifyResult)
	{
		VerifyResult restVerifyResult = new VerifyResult();
		restVerifyResult.recordId = verifyResult.recordId;
		restVerifyResult.complianceCode = verifyResult.complianceCode;
		restVerifyResult.passed = verifyResult.passed;
		restVerifyResult.failureReason = verifyResult.failureReason;
		return restVerifyResult;
	}
}
@RestResource(urlMapping='/compliance')
global with sharing class ComplianceResource 
{
	@HttpPost
	global static List<ComplianceService.VerifyResult> report(List<Id> Ids)
	{
		return ComplianceService.report(new Set<Id>(Ids));
	}
}
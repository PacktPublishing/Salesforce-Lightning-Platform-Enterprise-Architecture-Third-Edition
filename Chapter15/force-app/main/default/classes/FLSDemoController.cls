public with sharing class FLSDemoController {

	public Race__c Race {get;set;}

	public String Status { get { return Race.Status__c; }}

	public String FastestLapBy { get { return Race.FastestLapBy__c; }}

	public FLSDemoController() 
	{
		Race = [select Status__c, FastestLapBy__c from Race__c limit 1];	
	}

	@AuraEnabled
	public static Race__c getRace(Id raceId) {
		return [select Status__c, FastestLapBy__c from Race__c where id = :raceId];
	}
}
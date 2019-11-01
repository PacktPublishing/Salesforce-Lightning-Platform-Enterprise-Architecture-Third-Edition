public inherited sharing class TeamsSelector extends fflib_SObjectSelector {
	
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Team__c.Id,
			Team__c.Name,
			Team__c.TestingDistance__c
		};
	}

	public Schema.SObjectType getSObjectType() {
		return Team__c.sObjectType;
	}
}
public inherited sharing class ContestantsSelector extends fflib_SObjectSelector {
    
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Contestant__c.Id,
			Contestant__c.Name,
			Contestant__c.ChampionshipPoints__c,
			Contestant__c.DNF__c,
			Contestant__c.Driver__c,
			Contestant__c.DriverRace__c,
			Contestant__c.GridPosition__c,
			Contestant__c.Qualification1LapTime__c,
			Contestant__c.Qualification2LapTime__c,
			Contestant__c.Qualification3LapTime__c,
			Contestant__c.Race__c,
			Contestant__c.RacePosition__c,
			Contestant__c.RaceTime__c 
		};
	}

	public Schema.SObjectType getSObjectType() {
		return Contestant__c.sObjectType;
	}

	public List<Contestant__c> selectById(Set<Id> ids) {
		return (List<Contestant__c>) super.selectSObjectsById(ids);
	}
}
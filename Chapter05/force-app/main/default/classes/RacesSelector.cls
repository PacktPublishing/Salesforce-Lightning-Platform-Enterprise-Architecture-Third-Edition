public inherited sharing class RacesSelector extends fflib_SObjectSelector {
    
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Race__c.Id,
			Race__c.Name
		};
	}

	public Schema.SObjectType getSObjectType() {
		return Race__c.sObjectType;
	}

	public List<Race__c> selectByIdWithContestants(Set<Id> raceIds) {
		fflib_QueryFactory racesQueryFactory = newQueryFactory();
		fflib_QueryFactory contestantsSubQueryFactory =
			new ContestantsSelector().addQueryFactorySubselect(racesQueryFactory);          
		return (List<Race__c>) Database.query(
			racesQueryFactory.setCondition('Id in :raceIds').toSOQL());
	}
}
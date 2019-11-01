public inherited sharing class RacesSelector extends ApplicationSelector {
    
	public RacesSelector() {
		super();
	}

	public RacesSelector(Boolean includeFieldSetFields) {
		super(includeFieldSetFields);
	}

    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return new List<Schema.FieldSet> { 
        	SObjectType.Race__c.FieldSets.SeasonOverview 
        };
    }

	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Race__c.Id,
			Race__c.Name,
			Race__c.Status__c,
			Race__c.Season__c,
			Race__c.FastestLapBy__c,
			Race__c.PollPositionLapTime__c,
			Race__c.TotalDNFs__c
		};
	}

	public Schema.SObjectType getSObjectType() {
		return Race__c.sObjectType;
	}

	public List<Race__c> selectById(Set<Id> raceIds) {
		return (List<Race__c>) selectSObjectsById(raceIds);
	}

	public List<Race__c> selectByIdWithContestants(Set<Id> raceIds) {
	    fflib_QueryFactory racesQueryFactory = newQueryFactory();
	    fflib_QueryFactory contestantsSubQueryFactory = 
            new ContestantsSelector().addQueryFactorySubselect(racesQueryFactory); 	    
        return (List<Race__c>) Database.query(
            racesQueryFactory.setCondition('Id in :raceIds').toSOQL());
	}
}
public class RacesSelector extends ApplicationSelector {
    
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
			Race__c.Location__c,
			Race__c.Status__c,
			Race__c.Season__c,
			Race__c.FastestLapBy__c,
			Race__c.PollPositionLapTime__c,
			Race__c.TotalDNFs__c,
			Race__c.StartDate__c,
			Race__c.EndDate__c
		};
	}

	public Schema.SObjectType getSObjectType() {
		return Race__c.sObjectType;
	}

	public List<Race__c> selectById(Set<Id> raceIds) {
		return (List<Race__c>) selectSObjectsById(raceIds);
	}
	
	public override String getOrderBy() {
	    return Race__c.StartDate__c.getDescribe().getName() + ' DESC';
	}

	public List<Race__c> selectByIdWithContestants(Set<Id> raceIds) {
	    fflib_QueryFactory racesQueryFactory = newQueryFactory();
	    fflib_QueryFactory contestantsSubQueryFactory = 
            new ContestantsSelector().addQueryFactorySubselect(racesQueryFactory); 	    
        return (List<Race__c>) Database.query(
            racesQueryFactory.setCondition('Id in :raceIds').toSOQL());
	}
	
	public List<Race__c> selectAllForCurrentYear() {
        String currentYear = '2016'; // Hard coded to match sample data included in Chatper 9
        return (List<Race__c>) Database.query(
            newQueryFactory().setCondition('Season__r.Name = :currentYear').toSOQL());
	}
}
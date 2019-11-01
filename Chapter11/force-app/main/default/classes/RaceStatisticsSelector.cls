public class RaceStatisticsSelector extends ApplicationSelector {
    
	public RaceStatisticsSelector() {
		super();
	}

	public RaceStatisticsSelector(Boolean includeFieldSetFields) {
		super(includeFieldSetFields);
	}

	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			RaceStatistics__c.Id,
			RaceStatistics__c.Name,
			RaceStatistics__c.Race__c,			
            RaceStatistics__c.FastestSector1Driver__c,
            RaceStatistics__c.FastestSector1Time__c,
            RaceStatistics__c.FastestSector1TimeMilliseconds__c,
            RaceStatistics__c.FastestSector2Driver__c,
            RaceStatistics__c.FastestSector2Time__c,
            RaceStatistics__c.FastestSector2TimeMilliseconds__c,
            RaceStatistics__c.FastestSector3Driver__c,
            RaceStatistics__c.FastestSector3Time__c,
            RaceStatistics__c.FastestSector3TimeMilliseconds__c
		};
	}

	public Schema.SObjectType getSObjectType() {
		return RaceStatistics__c.sObjectType;
	}

	public List<RaceStatistics__c> selectById(Set<Id> idSet) {
        return (List<RaceStatistics__c>) selectSObjectsById(idSet);    
	}

	public List<RaceStatistics__c> selectByRaceId(Set<Id> raceIds) {
        return (List<RaceStatistics__c>) Database.query(newQueryFactory().setCondition('Race__c in :raceIds').toSOQL());
	}
}
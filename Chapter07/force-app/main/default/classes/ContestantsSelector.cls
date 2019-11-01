public inherited sharing class ContestantsSelector extends ApplicationSelector implements IContestantsSelector {
    
	public static IContestantsSelector newInstance()  { 
		return (IContestantsSelector) Application.Selector.newInstance(Contestant__c.SObjectType); 
	}

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

	public override String getOrderBy() {
		return 'Race__r.Season__r.Name, Race__r.Name, RacePosition__c';
	}

	public List<Contestant__c> selectById(Set<Id> ids) {
		return (List<Contestant__c>) super.selectSObjectsById(ids);
	}

	public List<Contestant__c> selectByIdWithDriver(Set<Id> driverIds) {
	    
	    fflib_QueryFactory contestantQueryFactory = newQueryFactory();
            
        new DriversSelector().
            configureQueryFactoryFields(
                contestantQueryFactory, 
                Contestant__c.Driver__c.getDescribe().getRelationshipName());
                
		return Database.query(
            contestantQueryFactory.setCondition('Id in :driverIds').toSOQL());
	}	

	public Map<Id, List<Summary>> selectByRaceIdWithContestantSummary(Set<Id> raceIds) {
	    
		Map<Id, List<Summary>> summariesByRaceId = new Map<Id, List<Summary>>();
				
		for(Contestant__c contestant : 
			Database.query(
			    newQueryFactory(false).
			        selectField(Contestant__c.RacePosition__c).
			        selectField('Race__r.Name').
                    selectField('Race__r.Season__r.Name').
                    selectField('Driver__r.Name').
                    selectField('Driver__r.Team__r.Name').
                    selectField('Car__r.Name').
			        setCondition('Race__c in :raceIds').
			        toSOQL())) {

			List<Summary> summaries = summariesByRaceId.get(contestant.Race__c);
			if(summaries==null)
				summariesByRaceId.put(contestant.Race__c, summaries = new List<Summary>());
			summaries.add(new Summary(contestant));
		}
		
		return summariesByRaceId;
	}

	public class Summary {
		private Contestant__c contestant;				
		public String Season { 
			get { return contestant.Race__r.Season__r.Name; }}		
		public String Race { 
			get { return contestant.Race__r.Name; } }	
		public Decimal Position { 
			get { return contestant.RacePosition__c; } }				
		public String Driver { 
			get { return contestant.Driver__r.Name; } }		
		public String Team { 
			get { return contestant.Driver__r.Team__r.Name; } }		
		public String Car { 
			get { return contestant.Car__r.Name; } }		
		@TestVisible			
		private Summary(Contestant__c contestant) { 
			this.contestant = contestant; }
	}
}
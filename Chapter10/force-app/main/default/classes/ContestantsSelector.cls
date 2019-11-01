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
			        selectField(Contestant__c.RaceTime__c).
			        selectField(Contestant__c.ChampionshipPoints__c).
			        selectField('Race__r.Name').
                    selectField('Race__r.Season__r.Name').
                    selectField('Driver__r.Name').
                    selectField('Driver__r.Team__r.Name').
                    selectField('Car__r.Name').
			        setCondition('Race__c in :raceIds AND Dnf__c = false').
			        toSOQL())) {

			List<Summary> summaries = summariesByRaceId.get(contestant.Race__c);
			if(summaries==null)
				summariesByRaceId.put(contestant.Race__c, summaries = new List<Summary>());
			summaries.add(new Summary(contestant));
		}
		
		return summariesByRaceId;
	}
	
	public List<Standing> selectStandingsForCurrentSeason() {
	    
	    // Aggregate points and wins by driver and team
        String currentYear = '2016'; // Hard coded to match sample data included in Chatper 9
        List<Standing> standings = new List<Standing>();
	    for(AggregateResult result : 
	           [select Driver__r.Name DriverName, 
	                   Driver__r.Team__r.Name TeamName, 
	                   SUM(ChampionshipPoints__c) Points, 
	                   SUM(Win__c) Wins
	               from Contestant__c
	               where Race__r.Season__r.Name = :currentYear
	               group by Driver__r.Name, Driver__r.Team__r.Name]) {
            standings.add(new Standing(result));
        }
        
        // Sort and assign positions
        standings.sort();
        Integer position = 1;
        for(Standing standing : standings) {
            standing.Position = position++;
        }
        
	    return standings;
	}

	public class Summary {
		private Contestant__c contestant;				
		public String Season { 
			get { return contestant.Race__r.Season__r.Name; }}		
		public String Race { 
			get { return contestant.Race__r.Name; } }	
		public Decimal Position { 
			get { return contestant.RacePosition__c; } }				
        public Decimal Points { 
            get { return contestant.ChampionshipPoints__c; } }                
        public Decimal RaceTime { 
            get { return contestant.RaceTime__c; } }                
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
    
    public class Standing implements Comparable {     
        private AggregateResult result;
        public Integer Position;
        public String Driver {
            get { return (String) result.get('DriverName'); }}
        public String Team {
            get { return (String) result.get('TeamName'); }}
        public Integer Wins {
            get { return Integer.valueOf(result.get('Wins')); }}
        public Integer Points {
            get { return Integer.valueOf(result.get('Points')); }}
        private Standing(AggregateResult result) { 
            this.result = result; }  
        public Integer compareTo(Object compare) {
            // Compare a compound of the points and team, e.g. 025Mercedes vs 010Ferrari
            Standing compareA = (Standing) compare;
            Standing compareB = this;
            Integer compareAPoints = compareA.Points==null ? 0 : compareA.Points;
            Integer compareBPoints = compareB.Points==null ? 0 : compareB.Points;            
            String compareACompound = String.valueOf(compareAPoints).leftPad(3).replace(' ', '0') + compareA.Team;
            String compareBCompound = String.valueOf(compareBPoints).leftPad(3).replace(' ', '0') + compareB.Team;
            return compareACompound.compareTo(compareBCompound);
        }
    }
}
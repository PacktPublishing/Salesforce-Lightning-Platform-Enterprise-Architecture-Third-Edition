public class RaceDataSelector extends ApplicationSelector {
    
	public static RaceDataSelector newInstance() { 
		return (RaceDataSelector) Application.Selector.newInstance(RaceData__c.SObjectType); 
	}

	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
				RaceData__c.Id,
				RaceData__c.Name,
				RaceData__c.Year__c,
				RaceData__c.RaceName__c,
				RaceData__c.Lap__c,
				RaceData__c.Sector__c,
				RaceData__c.Type__c,
				RaceData__c.Value__c,
				RaceData__c.DriverId__c
			};
	}

	public Schema.SObjectType getSObjectType() {
		return RaceData__c.sObjectType;
	}

	public List<RaceData__c> selectById(Set<ID> idSet) {
		return (List<RaceData__c>) selectSObjectsById(idSet);
	}	

	public List<RaceData__c> selectByRaceName(Set<String> raceNames) {
		return Database.query(newQueryFactory().setCondition('RaceName__c in :raceNames').toSOQL());
	}	

	public Database.QueryLocator selectAllQueryLocator() {
		return Database.getQueryLocator(newQueryFactory().toSOQL());
	}

	public List<Analysis> selectAnaysisGroupByRaceName() {
		List<Analysis> raceAnalysis = new List<Analysis>();
		for(AggregateResult result : 
			[select 
				RaceName__c raceName, Type__c type,
				AVG(Value__c) averageValue,
				MAX(Value__c) maxValue,
				MIN(Value__c) minValue
			 from RaceData__c
			 group by RaceName__c, Type__c ]) {
            raceAnalysis.add(new Analysis(result));			     
        }
		return raceAnalysis;
	}

	public class Analysis {
		private AggregateResult result;				
		public String Race { 
			get { return (String) result.get('raceName'); } }	
		public String Type { 
			get { return (String) result.get('type'); } }	
		public Decimal AverageValue { 
			get { return (Decimal) result.get('averageValue'); } }	
		public Decimal MaxValue { 
			get { return (Decimal) result.get('maxValue'); } }	
		public Decimal MinValue { 
			get { return (Decimal) result.get('minValue'); } }	
		private Analysis(AggregateResult result) { 
			this.result = result; }		
	}
}
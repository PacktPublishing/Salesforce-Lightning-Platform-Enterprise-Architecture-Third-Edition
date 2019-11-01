public inherited sharing class RaceLapHistorySummaries extends ApplicationDomain 
{
	public RaceLapHistorySummaries(List<RaceLapHistorySummary__c> races) {
		super(races);
	}

	/** 
	 * Format lap time and associate with a Race record (if available)
	 **/
	public override void onBeforeInsert() {

		// Build a map of applicable Races given a set of race external Ids        
		Set<String> raceExternalIds = new Set<String>();
		for(RaceLapHistorySummary__c history : (List<RaceLapHistorySummary__c>) this.Records) {
			raceExternalIds.add(history.RaceId__c);
		}

		// Calculate values for Race and Fastest Lap fields
		Map<String, Race__c> racesByExternalId = new RacesSelector().selectByExternalRaceIds(raceExternalIds);
		for(RaceLapHistorySummary__c history : (List<RaceLapHistorySummary__c>) this.Records) {
			// Resolve this manually rather than via an external lookup 
			//   (since this will fail summaries where corresponding Race records don't exist)
			Race__c race = racesByExternalId.get(history.RaceId__c);
			if(race!=null) {
				history.Race__c = race.Id;
			}
			// Format the time
			history.FastestLap__c = String.valueOf(Time.newInstance(0,0,0,Integer.valueOf(history.FastestLapTime__c)));
		}
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new RaceLapHistorySummaries(sObjectList);
		}
	}		
}
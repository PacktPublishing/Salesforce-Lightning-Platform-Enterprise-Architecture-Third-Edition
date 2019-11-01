public with sharing class RaceResultsController 
{
	@RemoteAction
	public static List<RaceService.ProvisionalResult> loadProvisionalResults(Id raceId)
	{
		return RaceService.calculateProvisionResults(
			new Set<Id> { raceId }).get(raceId);
	}

	@RemoteAction
	public static void saveConfirmedResults(Id raceId, List<RaceService.ProvisionalResult> results)
	{
		RaceService.applyRaceResults(
			new Map<Id, List<RaceService.ProvisionalResult>> { raceId => results});
	}	
}
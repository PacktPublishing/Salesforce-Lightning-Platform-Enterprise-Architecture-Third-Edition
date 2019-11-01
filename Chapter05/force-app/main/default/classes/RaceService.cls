public with sharing class RaceService {
    
	public static Map<Id, List<ProvisionalResult>> calculateProvisionResults(Set<Id> raceIds) {
		return service().calculateProvisionResults(raceIds);
	}

	public static void applyRaceResults(Map<Id, List<ProvisionalResult>> provisionalResultsByRaceId) {
		service().applyRaceResults(provisionalResultsByRaceId);
	}

	public static void awardChampionshipPoints(Set<Id> raceIds) {
		service().awardChampionshipPoints(raceIds);
	}

	private static IRaceService service() {
		return (IRaceService) Application.Service.newInstance(IRaceService.class);
	}

	public class RaceServiceException extends Exception {} 	

	public class ProvisionalResult {
		public Integer racePosition {get; set;}
		public Id contestantId {get; set;}
		public String contestantName {get; set;}		
	}
}
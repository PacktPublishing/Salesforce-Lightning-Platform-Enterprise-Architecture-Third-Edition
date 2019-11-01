public interface IRaceService {
    
    Map<Id, List<RaceService.ProvisionalResult>> calculateProvisionResults(Set<Id> raceIds);
    
    void applyRaceResults(Map<Id, List<RaceService.ProvisionalResult>> provisionalResultsByRaceId);
    
    void awardChampionshipPoints(Set<Id> raceIds);
}
public class RaceServiceImplStub implements IRaceService {
    
    public Map<Id, List<RaceService.ProvisionalResult>> calculateProvisionResults(Set<Id> raceIds) {
        
        // Dummy behaviour to allow the client to be developed 
        //    independent of the main service implementation 
        Id raceId = new List<Id>(raceIds)[0];
        RaceService.ProvisionalResult hamilton = new RaceService.ProvisionalResult();
        hamilton.racePosition = 1;
        hamilton.contestantName = 'Lewis Hamilton';
        hamilton.contestantId = 'a03b0000006WVph';
        RaceService.ProvisionalResult rubens = new RaceService.ProvisionalResult();
        rubens.racePosition = 2;
        rubens.contestantName = 'Rubens Barrichello';
        rubens.contestantId = 'a03b00000072xx9';
        return new Map<Id, List<RaceService.ProvisionalResult>> {
                new List<Id>(raceIds)[0] => 
                    new List<RaceService.ProvisionalResult> { hamilton, rubens } };
    }

    public void applyRaceResults(Map<Id, List<RaceService.ProvisionalResult>> provisionalResultsByRaceId) {
        throw new RaceService.RaceServiceException('Not implemented');
    }

    public void awardChampionshipPoints(Set<Id> raceIds) {
        throw new RaceService.RaceServiceException('Not implemented');
    }    
    
	public String generateSummaryAsCSV(Set<Id> raceIds) {
        throw new RaceService.RaceServiceException('Not implemented');
	}    
}
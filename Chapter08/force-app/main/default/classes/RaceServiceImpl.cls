public class RaceServiceImpl implements IRaceService {
    
    public Map<Id, List<RaceService.ProvisionalResult>> calculateProvisionResults(Set<Id> raceIds) {           
        throw new RaceService.RaceServiceException('Not implemented');
    }

    public void applyRaceResults(Map<Id, List<RaceService.ProvisionalResult>> provisionalResultsByRaceId) {
        throw new RaceService.RaceServiceException('Not implemented');
    }

    public void awardChampionshipPoints(Set<Id> raceIds) {
        
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

        // Query Races and contestants and bulkify list of all contestants
        List<Contestant__c> contestants = new List<Contestant__c>();
        for(Race__c race : new RacesSelector().selectByIdWithContestants(raceIds)) {
            contestants.addAll(race.Contestants__r);            
        }
        
        // Delegate to Contestant Domain class
        new Contestants(contestants).awardChampionshipPoints(uow);

        // Commit work
        uow.commitWork();
    }
    
	public String generateSummaryAsCSV(Set<Id> raceIds)
	{
		// Query summaries via custom selector method
		Map<Id, List<ContestantsSelector.Summary>> summariesByRaceId = 
			new ContestantsSelector().selectByRaceIdWithContestantSummary(raceIds);
		// Construct CSV output (note this is not a formal implementation of the CSV spec)
		String csvOutput = '';
		for(Id raceId : summariesByRaceId.keySet())
			for(ContestantsSelector.Summary raceContestantSummary : summariesByRaceId.get(raceId))
				csvOutput+= String.join(
					new Object[] { 
							raceContestantSummary.Season,
							raceContestantSummary.Race,
							raceContestantSummary.Position,
							raceContestantSummary.Driver,
							raceContestantSummary.Team,
							raceContestantSummary.Car
						} , ',') + '\r\n';
		return csvOutput;
	}
}
public with sharing class RaceSummaryController  {
    
	private ApexPages.StandardController standardController;

	public List<ContestantsSelector.Summary> Summary {get; set;}

	public RaceSummaryController(ApexPages.StandardController standardController) {
		this.standardController = standardController;
	}

	public PageReference loadSummary() {
		try {

			// Query summaries for this race
			Id raceId = standardController.getId();
			Map<Id, List<ContestantsSelector.Summary>> summariesByRaceId = 
				ContestantsSelector.newInstance().
					selectByRaceIdWithContestantSummary(
						new Set<Id> { raceId });

			// Populate view state
			if(summariesByRaceId.containsKey(raceId))
				Summary = summariesByRaceId.get(raceId);
			else
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No summaries for this race'));
		} catch (Exception e) {
			ApexPages.addMessages(e);			
		}
		return null;
	}
	
	public String getCSVContent() {
		return RaceService.generateSummaryAsCSV(
			new Set<Id> { standardController.getId() });
	}	
}
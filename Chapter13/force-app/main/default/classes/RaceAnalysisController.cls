public class RaceAnalysisController {
    
	private ApexPages.StandardSetController standardSetController;

	public RaceAnalysisController(ApexPages.StandardSetController standardSetController) {
		this.standardSetController = standardSetController;	
	}

	public PageReference analyizeRaceData() {
	    
		// Selected race names
		Set<String> raceNames = new Set<String>();
		for(Race__c selected : (List<Race__c>) standardSetController.getSelected())
			raceNames.add(selected.Name);

		// Query all race data for selected races
		List<RaceService.AnalysisResult> analysisResults = 
			RaceService.analizeData(raceNames);

		// Debug message
		ApexPages.addMessage(
			new ApexPages.Message(
				ApexPages.Severity.Info, 
				'Just read ' + Limits.getQueryRows() + ' rows from RaceData__c'));

		return null;
	}
}
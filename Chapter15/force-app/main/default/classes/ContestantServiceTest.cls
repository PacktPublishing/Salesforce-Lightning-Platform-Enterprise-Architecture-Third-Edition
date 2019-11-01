@isTest
private class ContestantServiceTest {
    	
	@isTest static void testAwardPoints() {
	    
		SeasonService.importSeasons(TestData.asJSON());
		ContestantService.awardChampionshipPoints(
			new Map<Id, SObject>([select Id from Contestant__c]).keySet());
	}

	@isTest static void testTemporary() {
		try {
			ContestantService.retireFromRace(null);
			System.assert(false);
		} catch (Exception e) {
			System.assertEquals('Not implemented', e.getMessage());
		}
	}
}
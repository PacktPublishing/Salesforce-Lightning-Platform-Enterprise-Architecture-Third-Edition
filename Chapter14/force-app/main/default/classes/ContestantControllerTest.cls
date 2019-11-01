@isTest
private class ContestantControllerTest {
    	
	@isTest static void testAwardPoints() {
		SeasonService.importSeasons(TestData.asJSON());
		ContestantController.awardPoints([select Id from Contestant__c LIMIT 1][0].Id);
	}
}
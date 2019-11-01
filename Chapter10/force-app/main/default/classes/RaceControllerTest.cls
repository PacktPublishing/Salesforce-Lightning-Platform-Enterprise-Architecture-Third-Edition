@isTest
private class RaceControllerTest {
    	
	@isTest 
	static void testAwardPoints() {
		SeasonService.importSeasons(TestData.asJSON());
		RaceController.awardPoints([select Id from Race__c LIMIT 1][0].Id);
	}
}
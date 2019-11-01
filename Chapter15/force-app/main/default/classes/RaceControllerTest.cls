@isTest
private class RaceControllerTest {
    	
	@isTest 
	static void testAwardPoints() {
		SeasonService.importSeasons(TestData.asJSON());
		RaceController.awardPoints([select Id from Race__c LIMIT 1][0].Id);
	}

	@IsTest
	private static void whenAwardPointsCalledIdPassedToService() {
	    
	    fflib_ApexMocks mocks = new fflib_ApexMocks();
	    	    
	    // Given
	    RaceServiceImpl mockService = (RaceServiceImpl) mocks.mock(RaceServiceImpl.class);
	    Application.Service.setMock(RaceService.class, mockService);
	    
	    // When
	    Id raceId = fflib_IDGenerator.generate(Race__c.SObjectType);
	    RaceController.awardPoints(raceId);
	    
	    // Then
	    ((RaceServiceImpl) mocks.verify(mockService, 1)).awardChampionshipPoints(new Set<Id> { raceId });
	}	
}
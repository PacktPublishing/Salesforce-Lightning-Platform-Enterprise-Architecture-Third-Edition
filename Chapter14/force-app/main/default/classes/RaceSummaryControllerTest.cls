@IsTest
private class RaceSummaryControllerTest  {
    
	private static Id TEST_RACE_ID = fflib_IDGenerator.generate(Race__c.SObjectType);

	@IsTest
	private static void testLoadSummaries() {
	    
		// Set mock implementation of ContestantsSelector
		Application.Selector.setMock(new ContestantsSelectorMock());

		// Invoke controller method to load summaries
		RaceSummaryController controller = 
			new RaceSummaryController(
				new ApexPages.StandardController(
					new Race__c(Id = TEST_RACE_ID)));
		PageReference pageRef = controller.loadSummary();

		// Assert view state from controller
		System.assertEquals(null, pageRef);
		System.assertEquals(1, controller.Summary.size());
		System.assertEquals('2014', controller.Summary[0].Season);
		System.assertEquals('Spa', controller.Summary[0].Race);
		System.assertEquals(1,  controller.Summary[0].Position);
		System.assertEquals('Lewis Hamilton', controller.Summary[0].Driver);
		System.assertEquals('Mercedes', controller.Summary[0].Team);
		System.assertEquals('MP4-29', controller.Summary[0].Car);
	}

	public class ContestantsSelectorMock implements IContestantsSelector {
	    
		public Map<Id, List<ContestantsSelector.Summary>> selectByRaceIdWithContestantSummary(Set<Id> raceIds)
		{
			// Assert this is our test Race ID
			Id raceId = (Id) raceIds.iterator().next();
			System.assertEquals(TEST_RACE_ID, raceId);

			// Create mock data record
			Contestant__c contestant = new Contestant__c();
			contestant.RacePosition__c = 1;
			contestant.Race__r = 
				new Race__c(Name = 'Spa',
					Season__r = 
						new Season__c(Name = '2014'));
			contestant.Driver__r = 
				new Driver__c(Name = 'Lewis Hamilton',
					Team__r = 
						new Team__c(Name = 'Mercedes'));
			contestant.Car__r = 
				new Car__c(Name = 'MP4-29');

			// Return mock response
			return new Map<Id, List<ContestantsSelector.Summary>> 
				{ raceId => new List<ContestantsSelector.Summary> { 
					new ContestantsSelector.Summary(contestant) } };
		}
		
        public Schema.SObjectType sObjectType() {
            return Contestant__c.SObjectType;
        }
        public List<SObject> selectSObjectsById(Set<Id> idSet) {
            throw new ContestantsSelectorMockException('Not implemented');
        }    		
	}
	
	public class ContestantsSelectorMockException extends Exception {}
}
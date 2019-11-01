@isTest
private class RaceServiceTest {
    	
	@isTest static void testAwardPoints() {
		SeasonService.importSeasons(TestData.SEASONSDATA);
		RaceService.awardChampionshipPoints(
			new Map<Id, SObject>([select Id from Race__c]).keySet());
	}

	@isTest static void testTemporary() {
	    
		// Production code path
		try { 
		    RaceService.calculateProvisionResults(null);
		} catch (Exception e) {}
        try { 
    		RaceService.applyRaceResults(null);
        } catch (Exception e) {}

		// Dummy code path
		Application.Service.setMock(IRaceService.class, new RaceServiceImplStub());
		RaceService.calculateProvisionResults(new Set<Id> { 'a01b0000005lmgk' });
		try {
			RaceService.applyRaceResults(null);
			System.assert(false);
		} catch (Exception e) {
			System.assertEquals('Not implemented', e.getMessage());
		}
	}
	
	@isTest static void testCSV() {
		SeasonService.importSeasons(TestData.SEASONSDATA);
		String csvOutput = RaceService.generateSummaryAsCSV(
			new Map<Id, SObject>([select Id from Race__c]).keySet());
		System.assertEquals('2013,Spain,,Lewis Hamilton,,\r\n', csvOutput);		
	}	
}
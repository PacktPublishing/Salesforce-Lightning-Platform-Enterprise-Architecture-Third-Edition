@isTest
private class SeasonControllerTest {
    	
	@isTest static void testNewsletter() {
		try {
			SeasonController.sendNewsletter(null);
			System.assert(false);
		} catch (AuraHandledException e) {
			System.assertEquals('Not implemented', e.getMessage());			
		}		
	}
}
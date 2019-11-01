@IsTest
public class ComplianceServiceTest  {
	@IsTest
	private static void testVerify() {
		// Test data
		Season__c season = new Season__c(
			Name = '2014', 
			Year__c = '2014');
		insert season;
		Team__c team = new Team__c(
			Name = 'Mercedes', 
			TestingDistance__c = 12000);
		insert team;
		Driver__c driver = new Driver__c(
			Name = 'Lewis Hamilton', 
			Team__c = team.Id,
			FIASuperLicense__c = true,
			DriverId__c = '42');
		insert driver;
		Race__c race = new Race__c(
			Name = 'Spa', 
			Status__c  = 'Scheduled', 
			Season__c = season.Id);
		insert race;
		Car__c car = new Car__c(
			Name = 'MP4-29', 
			Weight__c = 700);
		insert car;
		Contestant__c contestant = new Contestant__c(
			Driver__c = driver.Id, 
			Race__c = race.Id, 
			Car__c = car.Id);
		insert contestant;
		race.Status__c = 'Finished';
		update race;

		// TODO: Asserts
		Test.startTest();
		ComplianceService.verify(new Set<Id> { team.Id });
		ComplianceService.verify(new Set<Id> { driver.Id });
		ComplianceService.verify(new Set<Id> { car.Id });
		Test.stopTest();
	}
}
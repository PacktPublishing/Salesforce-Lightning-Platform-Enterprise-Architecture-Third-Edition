@IsTest
private class ContestantsTest 
{
	@IsTest
	private static void testAddContestantNoneScheduled()
	{
		// Test data
		Season__c season = new Season__c(Name = '2014', Year__c = '2014');
		insert season;
		Driver__c driver = new Driver__c(Name = 'Lewis Hamilton', DriverId__c = '42');
		insert driver;
		Race__c race = new Race__c(Name = 'Spa', Status__c  = 'In Progress', Season__c = season.Id);
		insert race;

		Test.startTest();
		try 
		{
			// Insert Contestant to In Progress race
			Contestant__c contestant = new Contestant__c(Driver__c = driver.Id, Race__c = race.Id);
			insert contestant;
			System.assert(false, 'Expected exception');
		}
		catch (DMLException e)
		{
			System.assertEquals(1, e.getNumDml());
			System.assertEquals('Contestants can only be added to scheduled races', e.getDmlMessage(0));
			System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));
		}
		Test.stopTest();
	}

	@IsTest
	private static void testChangeContestantNoneScheduled()
	{
		// Test data
		Season__c season = new Season__c(Name = '2014', Year__c = '2014');
		insert season;
		Driver__c driver = new Driver__c(Name = 'Lewis Hamilton', DriverId__c = '42');
		insert driver;
		Driver__c anotherDriver = new Driver__c(Name = 'A Another', DriverId__c = '43');
		insert anotherDriver;
		Race__c race = new Race__c(Name = 'Spa', Status__c  = 'Scheduled', Season__c = season.Id);
		insert race;
		Contestant__c contestant = new Contestant__c(Driver__c = driver.Id, Race__c = race.Id);
		insert contestant;
		race.Status__c = 'In Progress';
		update race;

		Test.startTest();
		try
		{
			contestant.Driver__c = anotherDriver.Id;
			update contestant;
		}
		catch (DmlException e)
		{
			System.assertEquals(1, e.getNumDml());
			System.assertEquals('You can only change drivers for scheduled races', e.getDmlMessage(0));
			System.assertEquals(Contestant__c.Driver__c, e.getDmlFields(0)[0]);
			System.assertEquals(StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION, e.getDmlType(0));
		}
		Test.stopTest();

	}

	@IsTest
	private static void testAddChampionshipPoints()
	{
		// Test data
		Season__c season = new Season__c(Name = '2014', Year__c = '2014');
		insert season;
		Driver__c driver = new Driver__c(Name = 'Lewis Hamilton', DriverId__c = '42');
		insert driver;
		Race__c race = new Race__c(Name = 'Spa', Status__c  = 'Scheduled', Season__c = season.Id);
		insert race;
		Contestant__c contestant = new Contestant__c(Driver__c = driver.Id, Race__c = race.Id);
		insert contestant;
		race.Status__c = 'Finished';
		update race;
		contestant.RacePosition__c = 1;
		update contestant;

		Test.startTest();
		Contestants contestants = new Contestants(new List<Contestant__c> { contestant });
		contestants.awardChampionshipPoints(Application.UnitOfWork.newInstance());
		System.assertEquals(25, ((Contestant__c) contestants.Records[0]).ChampionshipPoints__c);
		Test.stopTest();
	}
}
global with sharing class SeasonService {
    
	public static void issueNewsLetterCurrentSeason() {
		throw new SeasonServiceException(
			Application.ExceptionCode.NotImplemented, Label.NotImplemented);
	}
	
	public static void issueNewsLetters(Set<Id> seasonIds) {
		throw new SeasonServiceException(
			Application.ExceptionCode.NotImplemented, Label.NotImplemented);
	}

	public static void updateStandings(Set<Id> seasonIds) {
		throw new SeasonServiceException(
			Application.ExceptionCode.NotImplemented, Label.NotImplemented);
	}

	public static void updateStandings(List<UpdateStandings> updateStandings) {
		throw new SeasonServiceException(
			Application.ExceptionCode.NotImplemented, Label.NotImplemented);
	}
	
	global static void importSeasons(String jsonData) {
		// Parse JSON data
		System.debug(jsonData);
		SeasonsData seasonsData = 
			(SeasonsData) JSON.deserializeStrict(jsonData, SeasonService.SeasonsData.class);

		// Construct a Unit Of Work to capture the follow working
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

		Map<String, Driver__c> driversById = new Map<String, Driver__c>();
		for(DriverData driverData : seasonsData.drivers) {
		    // Create Driver__c record
			Driver__c driver = new Driver__c(
				Name = driverData.name,
				DriverId__c = driverData.driverId,
				Nationality__c = driverData.nationality,
				TwitterHandle__c = driverData.twitterHandle);
            if(driverData.fiaSuperLicense!=null)
                driver.FIASuperLicense__c = driverData.fiaSuperLicense;				
			uow.registerNew(driver);
			driversById.put(driver.DriverId__c, driver);
		}
		for(SeasonData seasonData : seasonsData.seasons) {
			// Create Season__c record
			Season__c season = new Season__c(
				Name = seasonData.year,
				Year__c = seasonData.year);
			uow.registerNew(season);
			for(RaceData raceData : seasonData.races) {
				// Create Race__c record
				Race__c race = new Race__c(Name = raceData.name);				
				uow.registerNew(race, Race__c.Season__c, season);
				for(ContestantData contestantData : raceData.contestants) {
					// Create Contestant__c record
					Contestant__c contestant = new Contestant__c(
							RacePosition__c = contestantData.racePosition,
							ChampionshipPoints__c = contestantData.championshipPoints,
							DNF__c = contestantData.dnf,
							Qualification1LapTime__c = contestantData.qualification1LapTime,
							Qualification2LapTime__c = contestantData.qualification2LapTime,
							Qualification3LapTime__c = contestantData.qualification3LapTime);
					uow.registerNew(contestant, Contestant__c.Race__c, race);
					uow.registerRelationship(contestant, 
						Contestant__c.Driver__c, driversById.get(contestantData.driverId));
				}
			}
		}
		// Insert records registered with uow above
		uow.commitWork();
	}	
	
	global static void createTestSeason() {
		importSeasons(TestData.asJSON());		
	}

	global class SeasonServiceException extends Application.ApplicationException {
		public SeasonServiceException(Application.ExceptionCode exceptionCode, String message) {
			super(exceptionCode, message);
		}
	} 

	public class UpdateStandings {
		public Id seasonId;
		public Boolean issueNewsLetter;

	}

	public class SeasonsData {
		public List<DriverData> drivers;
		public List<SeasonData> seasons;
	}

	public class DriverData {
		public String name;
		public String nationality;
		public String driverId;		
		public String twitterHandle;	
        public Boolean fiaSuperLicense;     			
	}

	public class SeasonData {
		public String year;
		public List<RaceData> races;
	}

	public class RaceData {
		public Integer round;
		public String name;
		public List<ContestantData> contestants;
	}

	public class ContestantData {
		public String driverId;
		public Integer racePosition;
		public Integer championshipPoints;
		public Boolean dnf;
		public Integer qualification1LapTime;
		public Integer qualification2LapTime;
		public Integer qualification3LapTime;
	}
}
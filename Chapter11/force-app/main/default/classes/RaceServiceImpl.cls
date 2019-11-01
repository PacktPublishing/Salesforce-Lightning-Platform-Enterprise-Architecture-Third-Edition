public inherited sharing class RaceServiceImpl implements IRaceService {
    
    public Map<Id, List<RaceService.ProvisionalResult>> calculateProvisionResults(Set<Id> raceIds) {           
        throw new RaceService.RaceServiceException('Not implemented');
    }

    public void applyRaceResults(Map<Id, List<RaceService.ProvisionalResult>> provisionalResultsByRaceId) {
        throw new RaceService.RaceServiceException('Not implemented');
    }

    public void awardChampionshipPoints(Set<Id> raceIds) {
        
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

        // Query Races and contestants and bulkify list of all contestants
        List<Contestant__c> contestants = new List<Contestant__c>();
        for(Race__c race : new RacesSelector().selectByIdWithContestants(raceIds)) {
            contestants.addAll(race.Contestants__r);            
        }
        
        // Delegate to Contestant Domain class
        new Contestants(contestants).awardChampionshipPoints(uow);

        // Send event notifying the press that the results are published
        uow.registerNew(
            new RaceNewsFeed__e(
                Category__c = 'Race News', 
                Content__c = 'Championship points have been officially calculated'));

        // Commit work
        uow.commitWork();
    }
    
	public String generateSummaryAsCSV(Set<Id> raceIds)
	{
		// Query summaries via custom selector method
		Map<Id, List<ContestantsSelector.Summary>> summariesByRaceId = 
			new ContestantsSelector().selectByRaceIdWithContestantSummary(raceIds);
		// Construct CSV output (note this is not a formal implementation of the CSV spec)
		String csvOutput = '';
		for(Id raceId : summariesByRaceId.keySet())
			for(ContestantsSelector.Summary raceContestantSummary : summariesByRaceId.get(raceId))
				csvOutput+= String.join(
					new Object[] { 
							raceContestantSummary.Season,
							raceContestantSummary.Race,
							raceContestantSummary.Position,
							raceContestantSummary.Driver,
							raceContestantSummary.Team,
							raceContestantSummary.Car
						} , ',') + '\r\n';
		return csvOutput;
	}
	
    public Map<Id, Integer> addDrivers(Map<Id, List<Id>> driversByRaceId) {
        
        // TODO: Provide a means to determine drivers current car for the season
        List<Car__c> cars = new CarsSelector().selectAll();
        if(cars.size()==0) {
            throw new RaceService.RaceServiceException('Must have at least one Car record in the system');          
        }        
        
        fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
 
        // Create Contestant__c records for each Driver for the given Race
        Map<Id, Integer> addedDriversByRace = new Map<Id, Integer>();
        for(Id raceId : driversByRaceId.keySet()) {
            for(Id driverId : driversByRaceId.get(raceId)) {
                Contestant__c contestant = new Contestant__c();
                contestant.Race__c = raceId;
                contestant.Driver__c = driverId;
                contestant.Car__c = cars[0].Id;
                uow.registerNew(contestant);                
            }
            addedDriversByRace.put(raceId, driversByRaceId.get(raceId).size());
        }       
 
        // Commit work
        uow.commitWork();
        
        return addedDriversByRace;
    }	

	public Id runProcessDataJob()
	{
		// TODO: Implement concurrency check and scope config (via custom setting)
		return Database.executeBatch(new ProcessRaceDataJob(), 2000);	
	}    
    
	public void processData(Set<Id> raceDataIds)
	{
		// Query Race Data records and update with Contestant relationship
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
		for(RaceData__c raceData : 
				(List<RaceData__c>)
					Application.Selector.selectById(raceDataIds))
		{
			// Associate Race Data record with a Contestant via Unique Id
			raceData.Contestant__r = 
				new Contestant__c(
					RaceDataId__c = 
						Contestants.makeRaceDataId(
							raceData.Year__c, 
							raceData.RaceName__c, 
							raceData.DriverId__c));
			uow.registerDirty(raceData);
		}
		// Update records
		uow.commitWork();
	}
        
	public List<RaceService.AnalysisResult> analizeData(Set<String> raceNames)
	{
		// Sample code to illustrate unbounded queries in Chatper 11
		List<RaceData__c> raceData = 
			RaceDataSelector.newInstance().selectByRaceName(raceNames);			
		return null;
	}

	/**
	 * Optimally ingests raw external telemetry for the currently active race
	 */
    public void ingestTelemetry(List<RaceService.Telemetry> telemetry) {
		Integer currentYear = 2019; // Hard coded for this sample code Chapter 11
		String currentRaceName = 'Spain'; // Hard coded for this sample code Chapter 11
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
		for(RaceService.Telemetry incommingData : telemetry) {
			RaceData__c raceData = new RaceData__c();
			raceData.Year__c = currentYear;
			raceData.RaceName__c = currentRaceName;
			raceData.DriverId__c = incommingData.DriverId;
			raceData.Lap__c = incommingData.Lap;
			raceData.Sector__c = incommingData.Sector;
			raceData.Type__c = incommingData.Type;
			raceData.Value__c = incommingData.Value;
			raceData.Contestant__r = 
				new Contestant__c(
					RaceDataId__c = 
						Contestants.makeRaceDataId(
							raceData.Year__c, 
							raceData.RaceName__c, 
							raceData.DriverId__c));
			uow.registerNew(raceData);
		}	
		uow.commitWork();	
	}

	/**
	 * Updates various persistant stats based on telemetry for known contestants
	*/
	public void processTelemetry(List<RaceService.ContestantResolvedTelemetry> telemetry) {

		// Query contestants to obtain their related races
		Set<Id> contestantIds = new Set<Id>();
		for(RaceService.ContestantResolvedTelemetry event : telemetry) {
			contestantIds.add(event.ContestantId);
		}
		Map<Id,Id> racesByContestantId = new Map<Id,Id>();
		for(Contestant__c contestant : new ContestantsSelector().selectById(contestantIds)) {
			racesByContestantId.put(contestant.Id, contestant.Race__c);
		}
		// Query the current Race Statistics
		Map<Id, RaceStatistics__c> statsByRaceId = new Map<Id, RaceStatistics__c>();
		for(RaceStatistics__c stat : new RaceStatisticsSelector().selectByRaceId( new Set<Id>(racesByContestantId.values()))) {
			statsByRaceId.put(stat.Race__c, stat);
		}

		// Adjust stats accordingly
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();		
		for(RaceService.ContestantResolvedTelemetry event : telemetry) {
			Id raceId = racesByContestantId.get(event.ContestantId);
			RaceStatistics__c stat = statsByRaceId.get(raceId);
			if(stat==null) {
				stat = new RaceStatistics__c();
				stat.Race__c = raceId;
			}
			// New fastest sector time?
			if(event.Type == 'Sector Time') {
				Decimal currentSectorTime = (Decimal) stat.get('FastestSector'+event.Sector+'TimeMilliseconds__c');
				if(currentSectorTime == null || event.Value < currentSectorTime) {
					stat.put('FastestSector'+event.Sector+'TimeMilliseconds__c', event.Value);
					stat.put('FastestSector'+event.Sector+'Time__c', String.valueOf(Time.newInstance(0,0,0,Integer.valueOf(event.Value))));
					stat.put('FastestSector'+event.Sector+'Driver__c', ''+event.ContestantId);
					uow.registerUpsert(stat);
				}
			}
		}
		uow.commitWork();
	}
}
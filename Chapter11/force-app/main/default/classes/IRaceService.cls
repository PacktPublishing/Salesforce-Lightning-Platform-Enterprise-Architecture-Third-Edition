public interface IRaceService {
    
    Map<Id, List<RaceService.ProvisionalResult>> calculateProvisionResults(Set<Id> raceIds);
    
    void applyRaceResults(Map<Id, List<RaceService.ProvisionalResult>> provisionalResultsByRaceId);
    
    void awardChampionshipPoints(Set<Id> raceIds);
    
	String generateSummaryAsCSV(Set<Id> raceIds);
	
	Map<Id, Integer> addDrivers(Map<Id, List<Id>> driversByRaceId);
	
	Id runProcessDataJob();
	
	void processData(Set<Id> raceDataIds);
	
	List<RaceService.AnalysisResult> analizeData(Set<String> raceNames);

	void ingestTelemetry(List<RaceService.Telemetry> telemetry);

	void processTelemetry(List<RaceService.ContestantResolvedTelemetry> telemetry);
}
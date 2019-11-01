public with sharing class RaceService {
    
	public static Map<Id, List<ProvisionalResult>> calculateProvisionResults(Set<Id> raceIds) {
		return service().calculateProvisionResults(raceIds);
	}

	public static void applyRaceResults(Map<Id, List<ProvisionalResult>> provisionalResultsByRaceId) {
		service().applyRaceResults(provisionalResultsByRaceId);
	}

	public static void awardChampionshipPoints(Set<Id> raceIds) {
		service().awardChampionshipPoints(raceIds);
	}
	
	public static String generateSummaryAsCSV(Set<Id> raceIds) {
		return service().generateSummaryAsCSV(raceIds);
	}
	
    public static Map<Id, Integer> addDrivers(Map<Id, List<Id>> driversByRaceId) {
        return service().addDrivers(driversByRaceId);
    }
    
    public static Id runProcessDataJob() {
        return service().runProcessDataJob();
    }
    
	public static List<AnalysisResult> analizeData(Set<String> raceNames) {
        return service().analizeData(raceNames);
    }
    
    public static void processData(Set<Id> raceDataIds) {
        service().processData(raceDataIds);    
    }

	public static void ingestTelemetry(List<RaceService.Telemetry> telemetry) {
		service().ingestTelemetry(telemetry);
	}

	public static void processTelemetry(List<RaceService.ContestantResolvedTelemetry> telemetry) {
		service().processTelemetry(telemetry);
	}

	private static IRaceService service() {
		return (IRaceService) Application.Service.newInstance(RaceService.class);
	}

	public class RaceServiceException extends Exception {} 	

	public class AnalysisResult {
	}

	public class ProvisionalResult {
		public Integer racePosition {get; set;}
		public Id contestantId {get; set;}
		public String contestantName {get; set;}		
	}

	public virtual class Telemetry {
		public String DriverId;
		public Integer Lap;
		public Integer Sector;
		public String Type;
		public Decimal Value;
	}

	public class ContestantResolvedTelemetry extends Telemetry {
		public String ContestantId;
	}
}
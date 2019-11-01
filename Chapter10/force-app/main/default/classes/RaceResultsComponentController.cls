public with sharing class RaceResultsComponentController {

    @AuraEnabled(cacheable=true)
    public static List<RaceResult> getRaceResults(Id raceId) {
        
        // Query race results via Contestant Selector
        Map<Id, List<ContestantsSelector.Summary>> summariesByRaceId = 
            ContestantsSelector.newInstance().
                selectByRaceIdWithContestantSummary(
                    new Set<Id> { raceId });
        List<ContestantsSelector.Summary> results = summariesByRaceId.get(raceId);                     
        if(results==null) {
            return new List<RaceResult>();
        }

        // Build race results for this component            
        List<RaceResult> raceResults = new List<RaceResult>();
        for(ContestantsSelector.Summary contestantSummary : results) {
            RaceResult raceResult = new RaceResult();
            raceResult.Driver = contestantSummary.Driver;
            raceResult.Team = contestantSummary.Team;
            raceResult.Grid = Integer.valueOf(contestantSummary.Position);
            raceResult.RaceTime = formatRaceTime(contestantSummary.RaceTime);
            raceResult.Points = Integer.valueOf(contestantSummary.Points); 
            raceResults.add(raceResult);
        }
                    
        return raceResults;
    }   
    
    /**
     * Takes the race time in number of seconds and formats to HH:MM:SS.Mileseconds
     **/
    public static String formatRaceTime(Decimal raceTime) {

        if(raceTime==null)
            return 'No Time';
	    long longVal = raceTime.longValue();
	    Integer hours = (Integer) longVal / 3600;
	    Integer remainder = (Integer) longVal - hours * 3600;
	    Integer mins = remainder / 60;
	    remainder = remainder - mins * 60;
	    Integer secs = remainder;
	    Integer fraction = Integer.valueOf((raceTime - Math.floor(raceTime))*1000);
        return hours + ':' + mins + ':' + secs + '.' + fraction;
    }
    
    public class RaceResult {
        @AuraEnabled
        public String Driver;
        @AuraEnabled
        public String Team;
        @AuraEnabled
        public Integer Grid;
        @AuraEnabled
        public String RaceTime;
        @AuraEnabled
        public Integer Points;
    } 
}
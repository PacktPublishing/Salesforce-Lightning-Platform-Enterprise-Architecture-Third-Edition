public with sharing class RaceStandingsComponentController {

    @AuraEnabled(cacheable=true)
    public static List<RaceStanding> getStandings() {
        try {
            List<RaceStanding> raceStandings = new List<RaceStanding>();
            for(ContestantsSelector.Standing standing : new ContestantsSelector().selectStandingsForCurrentSeason()) {
                RaceStanding raceStanding = new RaceStanding();
                raceStanding.Position = standing.Position;
                raceStanding.Driver = standing.Driver;
                raceStanding.Team = standing.Team;
                raceStanding.Wins = standing.Wins;
                raceStanding.Points = standing.Points;
                raceStandings.add(raceStanding);
            }
            return raceStandings;
        } catch (Exception e) {
            Application.throwAuraHandledException(e);
        }
        return null;
    }    
    
    public class RaceStanding {
        @AuraEnabled
        public Integer Position;
        @AuraEnabled
        public String Driver;
        @AuraEnabled
        public String Team;
        @AuraEnabled
        public Integer Wins;
        @AuraEnabled
        public Integer Points;
    }
}
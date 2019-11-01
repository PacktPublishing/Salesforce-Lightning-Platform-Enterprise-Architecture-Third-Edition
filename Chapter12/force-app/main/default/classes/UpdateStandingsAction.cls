global with sharing class UpdateStandingsAction {
    
	global class UpdateStandingsParameters {
	    @InvocableVariable(
	               Label='Season Id'
	               Description='Season to update the standings for'
	               Required=True)
        global Id seasonId;
	    @InvocableVariable(
	              Label='Issue News Letter' Description='Send the news letter out to the teams and drivers'
	              Required=False)
        global Boolean issueNewsLetter;
        
        private SeasonService.UpdateStandings makeUpdateStandings() {
            SeasonService.UpdateStandings updateStandings = new SeasonService.UpdateStandings();
            updateStandings.seasonId = this.seasonId;
            updateStandings.issueNewsLetter = this.issueNewsLetter;
            return updateStandings;
        }
	}    
	
	@InvocableMethod(
	   Label='Update the leaderboard of the season' 
	   Description='Updates the leaderborader and optionally sends the news letter.')
	global static void updateStandings(List<UpdateStandingsParameters> parameters) {
	    // Marshall parameters into service parameters
	    List<SeasonService.UpdateStandings> updateStandings = new List<SeasonService.UpdateStandings>();
	    for(UpdateStandingsParameters parameter : parameters) {
            updateStandings.add(parameter.makeUpdateStandings());
	    }
	    // Call the service
	    SeasonService.updateStandings(updateStandings);
	}	
}
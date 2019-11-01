public with sharing class ContestantService {
       
	public static void awardChampionshipPoints(Set<Id> contestantIds) {
	    
		// Apply championship points to selected contestants		
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();
		awardChampionshipPoints(uow, new ContestantsSelector().selectById(contestantIds));
		uow.commitWork();
	}

	public static void awardChampionshipPoints(fflib_ISObjectUnitOfWork uow, List<Contestant__c> contestants) {
	    
		// Apply championship points to given contestants
		Map<Integer, ChampionshipPoint__mdt> pointsByTrackPosition = 
		  new ChampionshipPointsSelector().selectAllByTrackPosition();		
		for(Contestant__c contestant : contestants) {
			// Determine points to award for the given position
			ChampionshipPoint__mdt pointsForPosition = 
                pointsByTrackPosition.get(Integer.valueOf(contestant.RacePosition__c));
			if(pointsForPosition!=null) {
				// Apply points and register for udpate with uow
				contestant.ChampionshipPoints__c = pointsForPosition.PointsAwarded__c;
				uow.registerDirty(contestant);
			}
		}		
	}

	public static void retireFromRace(List<RaceRetirement> retirements) {
		throw new ContestantServiceException('Not implemented');
	}

	public class ContestantServiceException extends Exception {} 

	public class RaceRetirement {
		public Id contestantId;
		public String reason;
	}	
}
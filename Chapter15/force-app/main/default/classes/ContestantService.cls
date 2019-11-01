global with sharing class ContestantService {
       
	public static void awardChampionshipPoints(Set<Id> contestantIds) {
	    
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance();

		// Apply championship points to given contestants		
		Contestants contestants = 
			new Contestants(
				new ContestantsSelector().selectById(contestantIds));
		contestants.awardChampionshipPoints(uow);

		uow.commitWork();
	}

	public static void retireFromRace(List<RaceRetirement> retirements) {
		throw new ContestantServiceException('Not implemented');
	}

	public class ContestantServiceException extends Exception {} 

	public class RaceRetirement {
		public Id contestantId;
		public String reason;
	}
		
	global interface IAwardChampionshipPoints
	{
		void calculate(List<Contestant__c> contestants);
	}	
}
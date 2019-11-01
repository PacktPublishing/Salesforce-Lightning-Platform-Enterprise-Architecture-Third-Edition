public with sharing class OutOfRaceController 
{
	private ApexPages.StandardSetController standardSetController;

	public OutOfRaceController(ApexPages.StandardSetController standardSetController) 
	{
		this.standardSetController = standardSetController;		
	}

	public PageReference markAsDNF()
	{
		for(Contestant__c contestant : (List<Contestant__c>) standardSetController.getSelected())
			contestant.DNF__c = true;		
		return null;
	}
}
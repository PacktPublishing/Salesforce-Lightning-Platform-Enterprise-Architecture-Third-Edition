public with sharing class ContestantController 
{
    public ContestantController(ApexPages.StandardController stdController) 
    {
    }

    public PageReference awardPoints()
    {
        ContestantService.awardChampionshipPoints(null);
        
        return null;
    }
}
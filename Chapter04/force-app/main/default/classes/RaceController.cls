public with sharing class RaceController 
{
    public RaceController(ApexPages.StandardController stdController) 
    {        
    }

    public PageReference awardPoints()
    {
        RaceService.awardChampionshipPoints(null);
        
        return null;
    }
}
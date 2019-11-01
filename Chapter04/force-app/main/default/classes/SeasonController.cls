public class SeasonController 
{
    public SeasonController(ApexPages.StandardController stdController) 
    {
    }

    public PageReference sendNewsletter()
    {
        SeasonService.issueNewsLetters(null);
        
        return null;
    }
}
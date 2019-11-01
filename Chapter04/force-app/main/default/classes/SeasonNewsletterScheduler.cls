global class SeasonNewsletterScheduler implements Schedulable 
{
	global void execute(SchedulableContext sc) 
	{
		SeasonService.issueNewsLetters(null);
	}
}
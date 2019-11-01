global with sharing class SeasonNewsletterScheduler implements Schedulable {
    
	global void execute(SchedulableContext sc) {
		try {
 			SeasonService.issueNewsLetterCurrentSeason();
		}
		catch (Exception e) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setTargetObjectId(UserInfo.getUserId());
			mail.setSenderDisplayName(UserInfo.getUserName());
			mail.setSubject('Failed to send Season Newsletter');
			mail.setHtmlBody(e.getMessage());
			mail.setSaveAsActivity(false);
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });			
		}
	}
}
public class ProcessRaceDataJob implements Database.Batchable<SObject> {
    
	public Database.QueryLocator start(Database.BatchableContext ctx) {
		return RaceDataSelector.newInstance().selectAllQueryLocator();
	}

	public void execute(Database.BatchableContext ctx, List<RaceData__c> scope) {
		try  {
			Set<Id> raceDataIds = new Map<Id, SObject>(scope).keySet();
			RaceService.processData(raceDataIds);
		} catch (Exception e) {
			LogService.log(ctx.getJobId(), e);
		}
	}

	public void finish(Database.BatchableContext ctx) {
		NotificationService.notify(ctx.getJobId(), 'Processed Race Data');
	}
}
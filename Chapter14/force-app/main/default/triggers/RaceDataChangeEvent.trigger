trigger RaceDataChangeEvent on RaceData__ChangeEvent (after insert) {
    List<RaceService.ContestantResolvedTelemetry> resovledTelemetry = 
        new List<RaceService.ContestantResolvedTelemetry>();
    for(RaceData__ChangeEvent event : Trigger.New) {
        EventBus.ChangeEventHeader header = event.ChangeEventHeader;
        if (header.changetype == 'CREATE' && event.Contestant__c!=null) {
            RaceService.ContestantResolvedTelemetry telemetry = 
                new RaceService.ContestantResolvedTelemetry();
            telemetry.ContestantId = event.Contestant__c;
            telemetry.DriverId = event.DriverId__c;
            telemetry.Lap = Integer.valueOf(event.Lap__c);
            telemetry.Sector = Integer.valueOf(event.Sector__c);
            telemetry.Type = event.Type__c;
            telemetry.Value = event.Value__c;
            resovledTelemetry.add(telemetry);
        }
    }
    RaceService.processTelemetry(resovledTelemetry); 
}
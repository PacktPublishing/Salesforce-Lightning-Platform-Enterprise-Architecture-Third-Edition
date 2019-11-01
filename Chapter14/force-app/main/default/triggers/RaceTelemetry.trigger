trigger RaceTelemetry on RaceTelemetry__e (after insert) {
    List<RaceService.Telemetry> incomingTelemetry = new List<RaceService.Telemetry>();
    for(RaceTelemetry__e event : Trigger.New) {
        RaceService.Telemetry telemetry = new RaceService.Telemetry();
        telemetry.DriverId = event.DriverId__c;
        telemetry.Lap = Integer.valueOf(event.Lap__c);
        telemetry.Sector = Integer.valueOf(event.Sector__c);
        telemetry.Type = event.Type__c;
        telemetry.Value = event.Value__c;
        incomingTelemetry.add(telemetry);
    }    
    RaceService.ingestTelemetry(incomingTelemetry); 
}
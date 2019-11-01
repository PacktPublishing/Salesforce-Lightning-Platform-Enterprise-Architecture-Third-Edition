public inherited sharing class ChampionshipPointsSelector extends fflib_SObjectSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            ChampionshipPoint__mdt.Id,
            ChampionshipPoint__mdt.DeveloperName,
            ChampionshipPoint__mdt.PointsAwarded__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return ChampionshipPoint__mdt.sObjectType;
    }
    
    public Map<Integer, ChampionshipPoint__mdt> selectAllByTrackPosition() {
        
        Map<Integer, ChampionshipPoint__mdt> pointsByTrackPosition = 
            new Map<Integer, ChampionshipPoint__mdt>();

        // Query custom metadata records and parse track position from DeveloperName field            
        for(ChampionshipPoint__mdt record : Database.query(newQueryFactory().toSOQL())) {
            Integer trackPosition = Integer.valueOf(record.DeveloperName.remove('TrackPosition'));
            pointsByTrackPosition.put(trackPosition, record);
        }
        
        return pointsByTrackPosition;
    }
}
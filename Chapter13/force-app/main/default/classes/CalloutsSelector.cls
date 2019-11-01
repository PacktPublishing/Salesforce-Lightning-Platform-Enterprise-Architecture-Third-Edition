public class CalloutsSelector extends fflib_SObjectSelector {
    
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Callout__mdt.Id,
            Callout__mdt.DeveloperName,
            Callout__mdt.NamespacePrefix,
            Callout__mdt.ApexCLass__c,
            Callout__mdt.ApexCLassNamespacePrefix__c,
            Callout__mdt.InterfaceType__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Callout__mdt.sObjectType;
    }
    
    public Map<Type, Type> selectAllCallouts() {        
        // Query custom metadata records for callouts
        Map<Type, Type> calloutsByInterfaceType = new Map<Type, Type>();                    
        for(Callout__mdt record : Database.query(newQueryFactory().toSOQL())) {
            if(Callout__mdt.ApexCLass__c!=null) {
                // Namespace of the interface is that of the custom metadata type 
                Type interfaceType = Type.forName(record.NamespacePrefix, record.InterfaceType__c);
                // Implementing class can optionally specify  the namespace if needed
                Type implType = Type.forName(record.ApexCLassNamespacePrefix__c, record.ApexCLass__c);
                calloutsByInterfaceType.put(interfaceType, implType);
            }
        }       
        return calloutsByInterfaceType;
    }
}
/**
 * Applicaiton specific Domain base class, customise fflib_SObjectDomain and add common behaviour
 **/
public inherited sharing abstract class ApplicationDomain extends fflib_SObjectDomain {
    public ApplicationDomain(List<SObject> records) {
        super(records);
        // Disable the base class CRUD checking in preference to explicit checking elsewhere
        Configuration.disableTriggerCRUDSecurity();
    }    
    
    /**
     * Helper method for determining in multi-company agnostic way the currency of each record (see Chapter 7)
     **/
    public Map<Id, String> getCurrencyCodes() {
        Map<Id, String> codesByRecordId = new Map<Id, String>();
        for(SObject record : Records) {
            codesByRecordId.put(record.Id, 
                UserInfo.isMultiCurrencyOrganization() ?
                    (String) record.get('CurrencyIsoCode') :
                    UserInfo.getDefaultCurrency());            
        }
        return codesByRecordId;
    }
}
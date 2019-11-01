/**
 * Applicaiton specific Domain base class, customise fflib_SObjectDomain and add common behaviour
 **/
public inherited sharing abstract class ApplicationDomain extends fflib_SObjectDomain {
    public ApplicationDomain(List<SObject> records) {
        super(records);
        // Disable the base class CRUD checking in preference to explicit checking elsewhere
        Configuration.disableTriggerCRUDSecurity();
    }    
}
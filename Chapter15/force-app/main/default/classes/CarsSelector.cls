public inherited sharing class CarsSelector extends ApplicationSelector 
{
	public List<Schema.SObjectField> getSObjectFieldList() {
		return new List<Schema.SObjectField> {
			Car__c.Id,
			Car__c.Name,
			Car__c.Weight__c
		};
	}

	public Schema.SObjectType getSObjectType() {
		return Car__c.sObjectType;
	}
		
    public List<Car__c> selectAll() {
        return (List<Car__c>) 
           Database.query(
               newQueryFactory().toSOQL());        
    }		
}
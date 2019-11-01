public inherited sharing class Seasons extends ApplicationDomain {
    
	public Seasons(List<Season__c> seasons) {
		super(seasons);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Seasons(sObjectList);
		}
	}	
}
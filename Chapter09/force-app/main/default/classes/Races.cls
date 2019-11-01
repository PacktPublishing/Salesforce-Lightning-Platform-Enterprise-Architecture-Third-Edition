public inherited sharing class Races extends ApplicationDomain 
{
	public Races(List<Race__c> races) {
		super(races);
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable {
		public fflib_SObjectDomain construct(List<SObject> sObjectList) {
			return new Races(sObjectList);
		}
	}		
}
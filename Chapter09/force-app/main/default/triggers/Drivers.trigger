trigger Drivers on Driver__c (after delete, after insert, after update, 
  before delete, before insert, before update) {
	fflib_SObjectDomain.triggerHandler(Drivers.class);
}
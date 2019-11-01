trigger Races on Race__c (after delete, after insert, after update, 
  before delete, before insert, before update) {
	fflib_SObjectDomain.triggerHandler(Races.class);
}
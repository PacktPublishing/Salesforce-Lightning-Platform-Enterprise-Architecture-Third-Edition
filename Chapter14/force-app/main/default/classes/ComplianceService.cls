global with sharing class ComplianceService 
{		
	/**
	 * Provides a full report, including confirmation and failures of the given reocrds
	 **/
	global static List<VerifyResult> report(Set<Id> recordIds) {
		// Dynamically create the Domain class instance for these records
		fflib_ISObjectDomain domain = Application.Domain.newInstance(recordIds);
		if(domain instanceof ICompliant) {
			// Ask the domain class to verify its compliance
			ICompliant compliantDomain = (ICompliant) domain;
			return compliantDomain.verifyCompliance();
		}
		throw new ComplianceException(
			Application.ExceptionCode.UnableToVerifyCompliance,
			Label.UnableToVerifyCompliance, 
			null);		
	}

	/**
	 * Provides general support to verify compliance in the application
	 **/
	public static void verify(Set<Id> recordIds) {
		// Dynamically create the Domain class instance for these records
		fflib_ISObjectDomain domain = Application.Domain.newInstance(recordIds);
		if(domain instanceof ICompliant) {
			// Ask the domain class to very its compliance
			ICompliant compliantDomain = (ICompliant) domain;
			List<VerifyResult> verifyResults = compliantDomain.verifyCompliance();
			if(verifyResults!=null) {
				// Check for failed compliances
				List<VerifyResult> failedCompliances = new List<VerifyResult>();
				for(VerifyResult verifyResult : verifyResults)
					if(!verifyResult.passed)
						failedCompliances.add(verifyResult);
				if(failedCompliances.size()>0)
					throw new ComplianceException(
						Application.ExceptionCode.ComplianceFailure, 
						Label.ComplianceFailuresFound, 
						failedCompliances);
			}
			return;
		}
		throw new ComplianceException(
			Application.ExceptionCode.UnableToVerifyCompliance,
			Label.UnableToVerifyCompliance, 
			null);
	}

	/**
	 * Custom exception class providing details of the compliance failures
	 **/
	global class ComplianceException extends Application.ApplicationException {
		global List<VerifyResult> failures {get; private set;}

		public ComplianceException(Application.ExceptionCode exceptionCode, String message, List<VerifyResult> failures) {
			super(exceptionCode, message);
			this.failures = failures;
		}	
	} 

	/** 
	 * Interface used to execute compliance checking logic in each domain class
	 **/
	public interface ICompliant {
		List<VerifyResult> verifyCompliance();
	}

	/**
	 * Results of a compliance verification for a given record
	 **/
	global class VerifyResult {
		global Id recordId;
		global String complianceCode;
		global Boolean passed;
		global String failureReason;
	}		
}
global class Application {
    
	// Configure and create the UnitOfWorkFactory for this Application
	public static final fflib_Application.UnitOfWorkFactory UnitOfWork = 
		new fflib_Application.UnitOfWorkFactory(
				new List<SObjectType> { 
					Driver__c.SObjectType, 
					Season__c.SObjectType, 
				  	Race__c.SObjectType, 
				  	Contestant__c.SObjectType });
				  	
    // Configure and create the ServiceFactory for this Application
    public static final fflib_Application.ServiceFactory Service = 
        new Application.ServiceFactory( 
            new Map<Type, Type> {
                    IRaceService.class => RaceServiceImpl.class });
                    
    // Configure and create the SelectorFactory for this Application
    public static final fflib_Application.SelectorFactory Selector = 
        new fflib_Application.SelectorFactory(
            // Map SObjectType to Selector Class
            new Map<SObjectType, Type> {
                    Team__c.SObjectType => TeamsSelector.class,
                    Race__c.SObjectType => RacesSelector.class,
                    Car__c.SObjectType => CarsSelector.class,
                    Driver__c.SObjectType => DriversSelector.class,
                    Contestant__c.SObjectType => ContestantsSelector.class }); 
                    
	// Configure and create the DomainFactory for this Application
	public static final fflib_Application.DomainFactory Domain = 
		new fflib_Application.DomainFactory(
			Application.Selector,
			// Map SObjectType to Domain Class Constructors 
			new Map<SObjectType, Type> {
					Team__c.SObjectType => Teams.Constructor.class,
					Race__c.SObjectType => Races.Constructor.class,
					Car__c.SObjectType => Cars.Constructor.class,
					Driver__c.SObjectType => Drivers.Constructor.class,
					Contestant__c.SObjectType => Contestants.Constructor.class });
					
    // Create an instance of the Callouts factory
    public static final CalloutFactory Callouts = new CalloutFactory();
           
    // Customised Service factory to support developer overrides via Custom Metadata (see Chapter 5)      
    private class ServiceFactory extends fflib_Application.ServiceFactory {
        
        private Map<String, String> servicesByClassName = new Map<String, String>();
        
        public ServiceFactory(Map<Type, Type> serviceInterfaceTypeByServiceImplType) {
            super(serviceInterfaceTypeByServiceImplType);
            
            // Map of overriden services defined by the developer in this org
            for(Service__mdt serviceOverride : 
                    [select DeveloperName, NamespacePrefix, ApexClass__c from Service__mdt]) {
                servicesByClassName.put(
                    serviceOverride.NamespacePrefix + '.' + serviceOverride.DeveloperName, 
                    serviceOverride.ApexClass__c);                
            }
        }
        
        public override Object newInstance(Type serviceInterfaceType) {
            
            // Has the developer overriden the Service implementaiton in their org?
            if(!Test.isRunningTest() && servicesByClassName.containsKey(serviceInterfaceType.getName())) {
                String overridenServiceImpl = servicesByClassName.get(serviceInterfaceType.getName());
                return Type.forName(overridenServiceImpl).newInstance();
            }
            
            // Default Service Factory returns mocked or registered default implementation
            return super.newInstance(serviceInterfaceType);    
        }        
    }

    /**
     * Simple factory class around the Callouts Custom Metadata type 
     **/    
    public class CalloutFactory {
        
        private Map<Type, Type> calloutsByInterface = new Map<Type, Type>();
        
        /**
         * Returns the registered implementation of the given interface
         **/
        public Object newInstance(Type interfaceType) {
            if(calloutsByInterface==null) {
                calloutsByInterface = new CalloutsSelector().selectAllCallouts();                
            }
            return calloutsByInterface.get(interfaceType);
        }
    }
    
	global enum ExceptionCode
	{
		NotImplemented,
		ComplianceFailure,
		UnableToVerifyCompliance
	}		

	global virtual class ApplicationException extends Exception 
	{
		global ExceptionCode ExceptionCode {get; private set;}

		public ApplicationException(ExceptionCode exceptionCode, String message)
		{
			this(message);
			this.exceptionCode = exceptionCode;
		}
	}	 

    /**
     * Utility method to throw Application exceptions to Lightning Components
     **/
    public static void throwAuraHandledException(Exception e) {
        String message = e.getMessage();
        AuraHandledException error = new AuraHandledException(message);
        error.setMessage(message); // Ensure Apex tests can assert the error message value
        throw error;
    }       
}
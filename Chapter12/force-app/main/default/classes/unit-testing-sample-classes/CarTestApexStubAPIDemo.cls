@IsTest
private class CarTestApexStubAPIDemo {
        
    @IsTest
    private static void whenCarStartCalledDashboardAndEngineInitialised() {
        
        // Given
        MockDashboard mockDashboard = new MockDashboard();
        MockEngine mockEngine = new MockEngine();
        
        // When
        Car car = new Car(mockEngine.createStub(), mockDashboard.createStub());
        car.start();
        
        // Then
        System.assert(car.isRunning());        
        System.assert(mockDashboard.initialiseCalled);
        System.assert(mockEngine.startCalled);
    }
    
    private class MockDashboard implements System.StubProvider {
        
        public Boolean initialiseCalled = false;
        
        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName, 
            Type returnType, 
            List<Type> listOfParamTypes, 
            List<String> listOfParamNames, 
            List<Object> listOfArgs) {

            // Record method call                
            if(stubbedMethodName == 'initialise') {
                initialiseCalled = true;
            }
            return null;
        }        
        
        public Dashboard createStub() {
            return (Dashboard) Test.createStub(Dashboard.class, this);            
        }
    }
    
    private class MockEngine implements System.StubProvider {

        public Boolean startCalled = false;
        public Boolean isRunningCalled = false;
        
        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName, 
            Type returnType, 
            List<Type> listOfParamTypes, 
            List<String> listOfParamNames, 
            List<Object> listOfArgs) {

            // Record method call    
            if(stubbedMethodName == 'isRunning') {
                isRunningCalled = true;
                return true;    
            } else if(stubbedMethodName == 'start') {
                startCalled = true;
            }
            return null;
        }        
        
        public Engine createStub() {
            return (Engine) Test.createStub(Engine.class, this);            
        }
    }
}
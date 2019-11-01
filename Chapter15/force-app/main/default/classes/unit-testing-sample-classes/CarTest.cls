@IsTest
private class CarTest {
    
    @IsTest
    private static void integrationTestStartCar() {
        
        // Given
        Display display = new Display();
        Dashboard dashboard = new Dashboard(display);
        Engine engine = new Engine(dashboard);
        
        // When
        Car car = new Car(engine, dashboard);
        car.start();
        
        // Then
        System.assertEquals(true, car.isRunning());
        System.assertEquals(true, engine.isRunning());
        System.assertEquals(true, display.isVisible());
        System.assertEquals('Hello Driver!', display.getMessageShowAt(10,20));
        System.assertEquals('RPM:1000', display.getMessageShowAt(10,10));
    }    
    
    @IsTest
    private static void whenCarStartCalledDashboardAndEngineInitialised() {
        
        // Given
        MockDashboard mockDashboard = new MockDashboard();
        MockEngine mockEngine = new MockEngine();
        
        // When
        Car car = new Car(mockEngine, mockDashboard);
        car.start();
        
        // Then
        System.assert(car.isRunning());        
        System.assert(mockDashboard.initialiseCalled);
        System.assert(mockEngine.startCalled);
    }
    
    private class MockDashboard implements IDashboard {
        public Boolean initialiseCalled = false;
        public Boolean updateRPMsCalled = false;
        public Integer updateRPMsCalledWith = null;
		public void initialise() { initialiseCalled = true; }
		public void updateRPMs(Integer rpms) { 
		    updateRPMsCalled = true; 
		    updateRPMsCalledWith = rpms; 
        }
		public void off() { }
    }
    
    private class MockEngine implements IEngine {
        public Boolean startCalled = false;
	    public void start() { startCalled = true; }    
	    public void stop() { }
	    public Boolean isRunning() { return true; }
    }
}
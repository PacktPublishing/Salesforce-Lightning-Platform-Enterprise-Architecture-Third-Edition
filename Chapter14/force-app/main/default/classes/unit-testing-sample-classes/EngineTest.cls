@IsTest
private class EngineTest {
    
    @IsTest
    private static void whenStartCalledDashboardUpdated() {
        
        // Given
        MockDashboard mockDashboard = new MockDashboard();
        
        // When
        Engine engine = new Engine(mockDashboard);
        engine.start();
        
        // Then
        System.assert(engine.isRunning());        
        System.assert(mockDashboard.updateRPMsCalled);
        System.assertEquals(1000, mockDashboard.updateRPMsCalledWith);
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
}
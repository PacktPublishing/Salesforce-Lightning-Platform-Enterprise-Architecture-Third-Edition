@IsTest
private class DashboardTestApexMocksDemo {

    @IsTest
    private static void whenUpdateRPMsCalledMessageIsDisplayed() {
        
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        
        // Given
        Display mockDisplay = (Display) mocks.mock(Display.class);
        
        // When
        Dashboard dashboard = new Dashboard(mockDisplay);
        dashboard.updateRPMs(5000);
        
        // Then
        ((Display) mocks.verify(mockDisplay, 1)).showMessage(10, 10, 'RPM:5000');        
    }    
}
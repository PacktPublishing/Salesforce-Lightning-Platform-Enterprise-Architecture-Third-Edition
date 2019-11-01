@IsTest
private class DashboardTest {

    @IsTest
    private static void whenUpdateRPMsCalledMessageIsDisplayed() {
        
        // Given
        MockDisplay mockDisplay = new MockDisplay();        
        
        // When
        Dashboard dashboard = new Dashboard(mockDisplay);
        dashboard.updateRPMs(5000);
        
        // Then
        System.assert(mockDisplay.showMessageCalled);
        System.assertEquals('RPM:5000', mockDisplay.showMessageCalledWithMessage);
    }

    private class MockDisplay implements IDisplay {
        public Boolean showMessageCalled = false;
        public String showMessageCalledWithMessage = null;
	    public void backlight(Boolean onOff) { }
	    public void showMessage(Integer positionX, Integer positionY, String message) {
            showMessageCalled = true;
            showMessageCalledWithMessage = message;
        }
	    public String getMessageShowAt(Integer positionX, Integer positionY) { return null; }
	    public Boolean isVisible() { return false; }
    }    
}
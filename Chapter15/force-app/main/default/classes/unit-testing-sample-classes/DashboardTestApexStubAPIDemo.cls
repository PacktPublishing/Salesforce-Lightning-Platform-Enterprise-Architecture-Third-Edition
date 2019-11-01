@IsTest
private class DashboardTestApexStubAPIDemo {
    
    @IsTest
    private static void whenUpdateRPMsCalledMessageIsDisplayed() {
        
        // Given
        MockDisplay mockDisplay = new MockDisplay();        
        
        // When
        Dashboard dashboard = new Dashboard(mockDisplay.createStub());
        dashboard.updateRPMs(5000);
        
        // Then
        System.assert(mockDisplay.showMessageCalled);
        System.assertEquals('RPM:5000', mockDisplay.showMessageCalledWithMessage);
    }

    private class MockDisplay implements System.StubProvider {
        
        public Boolean showMessageCalled = false;
        public String showMessageCalledWithMessage = null;

        public Object handleMethodCall(
            Object stubbedObject, 
            String stubbedMethodName, 
            Type returnType, 
            List<Type> listOfParamTypes, 
            List<String> listOfParamNames, 
            List<Object> listOfArgs) {

            // Record method call and parameter values   
            if(stubbedMethodName == 'showMessage') {
                showMessageCalled = true;
                showMessageCalledWithMessage = (String) listOfArgs[2];
            }
            return null;
        }        
        
        public Display createStub() {
            return (Display) Test.createStub(Display.class, this);            
        }
    }        
}
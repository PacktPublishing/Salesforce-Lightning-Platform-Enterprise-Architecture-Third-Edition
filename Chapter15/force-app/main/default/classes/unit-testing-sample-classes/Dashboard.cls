public class Dashboard implements IDashboard {
    
    private IDisplay display;
        
    public Dashboard() { 
        System.assert(Test.isRunningTest());
    }
    
    public Dashboard(IDisplay display) {
        this.display = display;
    }
    
    public void initialise() {
        display.backlight(true);
        display.showMessage(10, 20, 'Hello Driver!');        
    }
    
    public void updateRPMs(Integer rpms) {
        display.showMessage(10,10, 'RPM:' + rpms);
    }
    
    public void off() {        
        display.backlight(false);        
    }
}
public class Engine implements IEngine {

    private IDashboard dashboard;
    private Boolean isRunning;

    public Engine() {
        System.assert(Test.isRunningTest());
    }
    
    public Engine(IDashboard dashboard) {
        this.dashboard = dashboard;     
    }   
         
    public void start() {        
        dashboard.updateRPMs(1000);
        isRunning = true;
    }   
    
    public void stop() {
        dashboard.updateRPMs(0);
        isRunning = false;
    } 
    
    public Boolean isRunning() {
        return isRunning;
    }
}
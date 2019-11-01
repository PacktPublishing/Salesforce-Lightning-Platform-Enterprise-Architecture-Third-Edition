public class Car {
    
    private IEngine engine;
    private IDashboard dashboard;
    private Boolean isRunning;
    
    public Car(IEngine engine, IDashboard dashboard) {
        this.dashboard = dashboard;
        this.engine = engine;
    }
    
    public void start() {
        dashboard.initialise();
        engine.start();
    }
    
    public void stop() {
        engine.stop();        
        dashboard.off();
    }
    
    public Boolean isRunning() {
        return engine.isRunning();
    }
}
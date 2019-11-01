public class Display implements IDisplay {
        
    private Map<String, String> messagesByXY;
    private Boolean backlight;
    
    public Display() {
        messagesByXY = new Map<String, String>();         
    }
    
    public void backlight(Boolean onOff) {
        backlight = onOff;        
    }
    
    public void showMessage(
        Integer positionX, 
        Integer positionY, 
        String message) { 
        messagesByXY.put(positionX+':'+positionY, message);
    }
    
    public String getMessageShowAt(Integer positionX, Integer positionY) {
        return messagesByXY.get(positionX+':'+positionY);
    }  
    
    public Boolean isVisible() {
        return backlight;
    }  
}
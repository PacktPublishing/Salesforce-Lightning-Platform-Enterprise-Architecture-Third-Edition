public interface IDisplay {
    void backlight(Boolean onOff);
    void showMessage(Integer positionX, Integer positionY, String message);
    String getMessageShowAt(Integer positionX, Integer positionY);
    Boolean isVisible();
}
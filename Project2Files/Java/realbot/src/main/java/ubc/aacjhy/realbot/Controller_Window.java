package ubc.aacjhy.realbot;

import processing.core.PApplet;
import processing.serial.Serial;

import java.util.ArrayList;

public class Controller_Window extends Window {
    Serial myPort;

    public Controller_Window(PApplet p, String type, Serial myPort, int x, int y, int w, int h) {
        super(p, type, x, y, w, h);

        this.myPort = myPort;

        addButton("Stop", getX(), getY(), 40, 20);
    }

    @Override
    public void render() {
        render_base();
        render_buttons();
    }

    @Override
    public void mousePressedWindow() {
        Button button = getMousePressedButton();
        if (button != null) {
            button.pressed();
        }
    }

    public Button getMousePressedButton() {
        if (buttons.size() > 0) {
            for (Button button : buttons) {
                if ( p.mouseX > getX() + button.getX() && p.mouseX < getX() + button.getX() + button.getW() && p.mouseY > getX() + button.getY() && p.mouseY < getX() + button.getY() + button.getH()) {
                    return button;
                }
            }
        }
        return null;
    }
}

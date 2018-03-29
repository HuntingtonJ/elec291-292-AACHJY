package ubc.aacjhy.realbot;

import processing.core.PApplet;
import processing.serial.Serial;

import java.util.ArrayList;

public class Controller_Window extends Window {
    Serial myPort;

    Button pressed_button = null;

    Controller_Function_Matrix func_matrix;

    public Controller_Window(PApplet p, String type, Serial myPort, int x, int y, int w, int h) {
        super(p, type, x, y, w, h);

        this.myPort = myPort;

        addButton("stop", getX(), getY(), 40, 20);
        addButton("test", getX() + 60, getY(), 40, 20);
        func_matrix = new Controller_Function_Matrix(myPort, this);
    }

    @Override
    public void render() {
        render_base();
        render_buttons();
    }

    @Override
    public void mousePressedWindow() {
        pressed_button = getMousePressedButton();
        if (pressed_button != null) {
            pressed_button.pressed();
        }
    }

    @Override
    public void mouseReleasedWindow() {
        if (pressed_button != null) {
            func_matrix.executeFunction(pressed_button.getLabel());
            pressed_button.released();
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

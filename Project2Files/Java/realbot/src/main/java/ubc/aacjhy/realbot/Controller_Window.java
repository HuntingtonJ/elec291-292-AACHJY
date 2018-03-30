package ubc.aacjhy.realbot;

import processing.core.PApplet;
import processing.serial.Serial;

import java.util.ArrayList;

import static processing.core.PConstants.*;

public class Controller_Window extends Window {
    Serial myPort;

    Button pressed_button = null;

    Controller_Function_Matrix func_matrix;

    public Controller_Window(PApplet p, String type, Serial myPort, int x, int y, int w, int h) {
        super(p, type, x, y, w, h);

        this.myPort = myPort;

        func_matrix = new Controller_Function_Matrix(myPort, this);
        addButton("stop", func_matrix, 10, 10, 40, 20);                                     //stop  0
        addButton("test", func_matrix,60, 10, 40, 20);                              //test  1
        addButton("left", func_matrix, this.getWidth()/4 - 60, getY() + 100, 40, 20 );             //left  2
        addButton("right", func_matrix, this.getWidth()/4 + 20, getY() + 100, 40, 20);             //right 3
        addButton("up", func_matrix, this.getWidth()/4 - 20, getY() + 80, 40, 20);                 //up    4
        addButton("down", func_matrix, this.getWidth()/4 - 20, getY() + 120, 40, 20);              //down  5
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

    @Override
    public void keyPressed(int keyCode) {
        switch(keyCode) {
            case LEFT:
                pressed_button = buttons.get(2);
                break;
            case RIGHT:
                pressed_button = buttons.get(3);
                break;
            case UP:
                pressed_button = buttons.get(4);
                break;
            case DOWN:
                pressed_button = buttons.get(5);
                break;
            default:
                break;
        }
        pressed_button.pressed();
        func_matrix.executeFunction(pressed_button.getLabel());
    }

    @Override
    public void keyReleased() {
        if (pressed_button != null) {
            pressed_button.released();
            func_matrix.executeFunction("stop");
        }
    }

    public Button getMousePressedButton() {
        if (buttons.size() > 0) {
            for (Button button : buttons) {
                if ( p.mouseX > getFullX() + button.getX() && p.mouseX < getFullX() + button.getX() + button.getW() && p.mouseY > getFullY() + button.getY() && p.mouseY < getFullY() + button.getY() + button.getH()) {
                    return button;
                }
            }
        }
        return null;
    }


}

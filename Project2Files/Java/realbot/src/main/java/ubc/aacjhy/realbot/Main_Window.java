package ubc.aacjhy.realbot;

import processing.core.PApplet;
import processing.serial.Serial;

import java.util.ArrayList;

public class Main_Window extends Window {
    private ArrayList<Window> windows;

    private Serial myPort;
    private boolean console_f = false;
    private boolean midi_f = false;

    public Window selected_window;

    public Main_Window(PApplet p, String type, Serial myPort) {
        super(p, type,0, 0, p.width, p.height);

        this.myPort = myPort;

        windows = new ArrayList<Window>();
    }

    @Override
    public void render() {
        for (Window window : windows) {
            window.render();
        }
    }

    public void addWindow(Window nbr, int type, int resize_axis) {
        Window new_window;
        switch(type) {
            case 0:
                new_window = new Midi_Window(p, "midi_sequencer", myPort,0, 0, p.width, p.height);
                midi_f = true;
                break;
            case 1:
                new_window = new Console_Window(p, "console", myPort,0, 0, p.width, p.height);
                console_f = true;
                break;
            case 2:
                new_window = new Controller_Window(p, "controller", myPort, 0, 0, p.width, p.height);
                break;
            default:
                return;
        }

        if (nbr != this && new_window != null) {
            resizeWindows(nbr, new_window, resize_axis);
        }
        windows.add(new_window);
    }

    public Window getWindow(int index) {
        if (index < windows.size()) {
            return windows.get(index);
        }
        return null;
    }

    private void resizeWindows(Window one, Window two, int resize_axis) {
        if (resize_axis == 0) {
            two.setFullX(one.getFullX() + one.getFullWidth() / 2);
            two.setFullY(one.getFullY());
            two.setFullWidth(one.getFullWidth() / 2);
            two.setFullHeight((one.getFullHeight()));

            one.setFullWidth(two.getFullX() - one.getFullX());
        } else {
            two.setFullX(one.getFullX());
            two.setFullY(one.getFullY() + one.getFullHeight()/2);
            two.setFullWidth(one.getFullWidth());
            two.setFullHeight(one.getFullHeight()/2);

            one.setFullHeight(two.getFullY() - one.getFullY());
        }
        one.updateValues();
        two.updateValues();
    }

    public Window getMouseWindow() {
        for (Window window : windows) {
            if (p.mouseX >= window.getX() && p.mouseX <= window.getX() + window.getWidth() && p.mouseY >= window.getY() && p.mouseY <= window.getY() + window.getHeight()) {
                if (window == selected_window) {
                    return window;
                } else {
                    if (selected_window != null) {
                        selected_window.clearSelected();
                    }
                    selected_window = window;
                    selected_window.setSelected();
                }
                return window;
            }
        }
        return this;
    }

    public Console_Window getConsole() {
        if (console_f) {
            return (Console_Window)windows.get(1);
        }
        return null;
    }
}

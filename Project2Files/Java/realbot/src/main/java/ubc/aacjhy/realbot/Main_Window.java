package ubc.aacjhy.realbot;

import processing.core.PApplet;
import processing.serial.Serial;

import java.util.ArrayList;

public class Main_Window extends Window {
    private ArrayList<Window> windows;

    private Serial myPort;
    private boolean console_f = false;
    private boolean mide_f = false;

    public Main_Window(PApplet p, Serial myPort) {
        super(p,0, 0, p.width, p.height);

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
                new_window = new Midi_Window(p, myPort, 0, 0, p.width, p.height);
                mide_f = true;
                break;
            case 1:
                new_window = new Console_Window(p, myPort, 0, 0, p.width, p.height);
                console_f = true;
                break;
            default:
                return;
        }

        if (nbr != this) {
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
        if (p.mouseX >= windows.get(0).getX() && p.mouseX <= windows.get(0).getX() + windows.get(0).getWidth() && p.mouseY >= windows.get(0).getY() && p.mouseY <= windows.get(0).getY() + windows.get(0).getHeight()) {
            return windows.get(0);
        }
        return windows.get(0);
    }

    public Console_Window getConsole() {
        if (console_f) {
            return (Console_Window)windows.get(1);
        }
        return null;
    }
}

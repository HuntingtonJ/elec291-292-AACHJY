package ubc.aacjhy.realbot;

import processing.serial.Serial;

public class Controller_Function_Matrix {
    private Serial myPort;
    private final Controller_Window controller_window;

    public Controller_Function_Matrix(Serial myPort, Controller_Window w) {
        this.myPort = myPort;
        this.controller_window = w;
    }

    public void executeFunction(String label) {
        switch(labelToInt(label)) {
            case 0: //
                myPort.write("-/ s 0" + "\n");
                break;
            case 1:
                myPort.write("-t\n");
                break;
            default:
                controller_window.p.print("Invalid Button Label\n");
                break;
        }
    }

    private int labelToInt(String label) {
        if (label.equals("stop")) {
            return 0;
        } else if (label.equals("test")) {
            return 1;
        }

        return -1;
    }
}

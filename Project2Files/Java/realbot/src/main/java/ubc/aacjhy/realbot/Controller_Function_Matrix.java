package ubc.aacjhy.realbot;

import processing.serial.Serial;

public class Controller_Function_Matrix extends Function_Matrix {
    private Serial myPort;
    private final Controller_Window controller_window;

    public Controller_Function_Matrix(Serial myPort, Controller_Window w) {
        this.myPort = myPort;
        this.controller_window = w;
    }

    @Override
    public void executeFunction(String label) {
        switch(labelToInt(label)) {
            case 0: //
                myPort.write("-/ s 0\n");
                break;
            case 1:
                myPort.write("-t\n");
                break;
            case 2:
                myPort.write("-/ d 30\n");
                break;
            case 3:
                myPort.write("-/ p 30\n");
                break;
            case 4:
                myPort.write("-/ f 30\n");
                break;
            case 5:
                myPort.write("-/ r 30\n");
                break;
            default:
                controller_window.p.print("Invalid Button Label\n");
                break;
        }
    }

    @Override
    protected int labelToInt(String label) {
        if (label.equals("stop")) {
            return 0;
        } else if (label.equals("test")) {
            return 1;
        } else if (label.equals("left")) {
            return 2;
        } else if (label.equals("right")) {
            return 3;
        } else if (label.equals("up")) {
            return 4;
        } else if (label.equals("down")) {
            return 5;
        }
        return -1;
    }
}

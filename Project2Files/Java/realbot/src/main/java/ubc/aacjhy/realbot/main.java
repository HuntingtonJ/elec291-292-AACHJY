package ubc.aacjhy.realbot;

import processing.core.PApplet;
import processing.core.PFont;
import processing.serial.Serial;

public class main extends PApplet {

    private Serial myPort;

    private String inString;

    private int lf = 10;

    private boolean shift_flag = false;
    private int mode = 0;
    private int octave = 3;

    private Main_Window main_window;

    PFont hacker_font;

    public static void main(String[] args) {
        PApplet.main("ubc.aacjhy.realbot.main", args);
    }

    public void settings() {
        size(500, 500);
    }

    public void setup() {
        printArray(Serial.list());
        myPort = new Serial(this, Serial.list()[0], 115200);
        myPort.bufferUntil(lf);

        main_window = new Main_Window(this, myPort);
        main_window.addWindow(main_window,0, 0);
        main_window.addWindow(main_window.getWindow(0), 1, 1);

        hacker_font = createFont("/ttf/Hack-Regular.ttf", 12);
        textFont(hacker_font);
        textAlign(LEFT, TOP);
    }

    public void draw() {
        background(0);
        main_window.render();
    }
    
    public void serialEvent(Serial p) {
        inString = p.readString();
        main_window.getConsole().addLine(inString);
    }

    public void mousePressed() {
        switch (mode) {
            case 0:
                break;
            case 1:
            case 2:
                if (mouseButton == LEFT) {
                    main_window.getMouseWindow().mousePressedWindow();
                }
                break;
            default:
                break;
        }
    }

    public void mouseReleased() {
        switch (mode) {
            case 0:
                break;
            case 1:
            case 2:
                if (mouseButton == LEFT) {
                    main_window.getMouseWindow().mouseReleasedWindow();
                }
                break;
            default:
                break;
        }
    }


    public void keyPressed() {
        if (mode == 0) {
            switch (keyCode) {
                case ENTER:
                    main_window.getConsole().sendOutString();
                    break;
                case 'M':
                    mode = 1;
                default:
                    if (!shift_flag) {
                        main_window.getConsole().appendOutString((char)keyCode);
                    }
                    break;
            }
        } else if (mode == 1) {
            switch (keyCode) {
                case 'A':
                    myPort.write("-f " + 65 * pow(2, octave) + "\n"); //C2
                    break;
                case 'S':
                    myPort.write("-f " + 73 * pow(2, octave) + "\n"); //D2
                    break;
                case 'D':
                    myPort.write("-f " + 82 * pow(2, octave) + "\n"); //E2
                    break;
                case 'F':
                    myPort.write("-f " + 87 * pow(2, octave) + "\n"); //F2
                    break;
                case 'G':
                    myPort.write("-f " + 98 * pow(2, octave) + "\n"); //G2
                    break;
                case 'H':
                    myPort.write("-f " + 110 * pow(2, octave) + "\n"); //A2
                    break;
                case 'J':
                    myPort.write("-f " + 123 * pow(2, octave) + "\n"); //B2
                    break;
                case 'K':
                    myPort.write("-f " + 131 * pow(2, octave) + "\n"); //C3
                    break;
                case 'Z':
                    octave--;
                    if (octave < 0)
                        octave = 0;
                    break;
                case 'X':
                    octave++;
                    if (octave == 5)
                        octave = 4;
                    break;
                case 'M':
                    mode = 0;
                    break;
                case 'P':
                    mode = 2;
                    break;
                default:
                    break;
            }
        } else if (mode == 2) {
            switch (keyCode) {
                case 'P':
                    mode = 1;
                    break;
                default:
                    break;
            }
        }
    }
}

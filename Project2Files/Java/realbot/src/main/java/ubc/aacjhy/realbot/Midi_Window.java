package ubc.aacjhy.realbot;

import processing.core.PApplet;
import processing.core.PVector;
import processing.serial.Serial;

import java.util.ArrayList;

public class Midi_Window extends Window {
    Serial myPort;

    private int edit_mode = 0;
    private boolean midi_edit_f = false;

    private int selected_length;

    private ArrayList<Midi_Note> notes;
    private Midi_Note selected_note;

    private boolean key_played_f = false;
    private int key;

    private int bar_width;
    private int bar_count = 4;

    private int key_board_width = 40;
    private int note_lane_height;
    private int key_count = 36;

    private PVector even_color = new PVector(140, 140, 140);
    private PVector odd_color = new PVector(100, 100, 100);
    private PVector note_color = new PVector(255, 102, 0);
    private PVector selected_note_color = new PVector(255, 51, 0);

    public Midi_Window(PApplet p, String type, Serial port, int x, int y, int w, int h) {
        super(p, type, x, y, w ,h);

        this.myPort = port;

        notes = new ArrayList<Midi_Note>();

        updateValues();
    }

    @Override
    protected void updateValues() {
        this.bar_width = (getWidth() - key_board_width)/bar_count;
        this.note_lane_height = (getHeight())/key_count;
        this.selected_length = bar_width/8;
    }

    //Renders the window.
    @Override
    public void render() {
        this.render_base();
        this.render_note_lanes();
        this.render_keys();
        this.render_midi_notes();
    }

    //renders piano keyboard on the left
    private void render_keys() {
        //Sets black stroke and smallest weight
        p.stroke(0);
        p.strokeWeight(1);

        //For loop generates each key
        for (int i = 0; i < key_count; i++) {
            //Checks key fill color
            //If note is currently played, fill is red
            if (i == this.key && key_played_f) {
                p.fill(255, 0, 0);
                //Black notes
            } else if ( i == 1 || i == 3 || i == 5 ||
                    i == 8 || i == 10 ||
                    i == 13 || i == 15 || i == 17 ||
                    i == 20 || i == 22 ||
                    i == 25 || i == 27 || i == 29 ||
                    i == 32 || i == 34) {
                p.fill(0);
                //Otherwise fills with white.
            } else {
                p.fill(255);
            }

            //Draws a rectangle for each key.
            p.rect(getX(), getY() + i*note_lane_height, key_board_width, note_lane_height);
        }
    }

    //renders note lanes for midi notes on the right
    private void render_note_lanes() {
        p.noStroke();
        for (int i = 0; i < key_count; i++) {
            if (i%2 == 0) {
                p.fill(even_color.x, even_color.y, even_color.z);
            } else {
                p.fill(odd_color.x, odd_color.y, odd_color.z);
            }

            p.rect(getX() + key_board_width, getY() + i*note_lane_height, getWidth() - key_board_width, note_lane_height);
        }

        p.stroke(230);
        p.strokeWeight(1);

        for (int i = 1; i <= bar_count; i++) {
            p.line(getX() + key_board_width + i*bar_width, getBezelWidth(), getX() + key_board_width + i*bar_width, getBezelWidth() + getHeight());
        }
    }

    //renders midi notes in lanes
    private void render_midi_notes() {
        p.stroke(0);
        p.fill(note_color.x, note_color.y, note_color.z);

        for (Midi_Note note : notes) {
            if (midi_edit_f && note == selected_note) {
                p.fill(selected_note_color.x, selected_note_color.y, selected_note_color.z);

                p.rect(getX() + key_board_width + note.start, getY() + note.value*note_lane_height,(p.mouseX - (selected_note.start + getX() + key_board_width))/selected_length * selected_length, note_lane_height);
            }
            p.rect(getX() + key_board_width + note.start, getY() + note.value * note_lane_height, note.length, note_lane_height);
        }
    }

    //Performs tasks for mouse clicks in this window.
    @Override
    public void mousePressedWindow() {
        if (p.mouseX > getX() + key_board_width) {
            if (edit_mode == 0) {
                midi_edit_f = true;
                addMidiNote(p.mouseX, p.mouseY);
            } else if (edit_mode == 1) {
                removeMidiNote();
            }
        } else {
            key_played_f = true;
            playFreq(keyBoardPressed(p.mouseY));
        }
    }

    //Performs tasks for mouse releases in this window.
    @Override
    public void mouseReleasedWindow() {
        if (key_played_f) {
            //myPort.write("-o" + "\n");
            key_played_f = false;
        } else if (midi_edit_f) {
            if ( p.mouseX > selected_note.start + selected_note.length + getX() + key_board_width ) {
                selected_note.setLength( (p.mouseX - (selected_note.start + getX() + key_board_width))/selected_length * selected_length );
            }
            midi_edit_f = false;
            selected_note = null;
        }
    }

    //Adds a midi note to the Notes array.
    private void addMidiNote(int mx, int my) {
        int x = (mx - getX() - key_board_width)/selected_length;
        int y = (my - getY())/note_lane_height;
        Midi_Note new_note = new Midi_Note(x*selected_length, selected_length, y);
        selected_note = new_note;
        notes.add(new_note);
    }

    //Removes a midi note to the Notes array.
    private void removeMidiNote() {

    }

    //Sends a reload value to the microcontroller
    private void playFreq(int reload) {
        myPort.write("-r " + reload + "\n");
    }

    //Takes a keyBoard keyCode and returns a reload value
    private int keyBoardPressed(int my) {
        switch((my - getY())/note_lane_height) {
            case 0:
                key = 0;
                return 65293;  //b 3
            case 1:
                key = 1;
                return 65279;  //b_b 3
            case 2:
                key = 2;
                return 65263;  //a 3
            case 3:
                key = 3;
                return 65247;//a_b 3
            case 4:
                key = 4;
                return 65230;  //g 3
            case 5:
                key = 5;
                return 65212;  //g_b 3
            case 6:
                key = 6;
                return 65192;  //f 3
            case 7:
                key = 7;
                return 65171;  //e 3
            case 8:
                key = 8;
                return 65150;  //e_b 3
            case 9:
                key = 9;
                return 65127;  //d 3
            case 10:
                key = 10;
                return 65103;  //d_b 3
            case 11:
                key = 11;
                return 65077;  //c 3
            case 12:
                key = 12;
                return 65050;  //b 2
            case 13:
                key = 13;
                return 65021;  //b_b 2
            case 14:
                key = 14;
                return 64991;  //a 2
            case 15:
                key = 15;
                return 64958;  //a_b 2
            case 16:
                key = 16;
                return 64924;  //g 2
            case 17:
                key = 17;
                return 64887;  //g_b 2
            case 18:
                key = 18;
                return 64849;  //f 2
            case 19:
                key = 19;
                return 64808;  //e 2
            case 20:
                key = 20;
                return 64755;  //e_b 2
            case 21:
                key = 21;
                return 64719;  //d 2
            case 22:
                key = 22;
                return 64670;  //d_b 2
            case 23:
                key = 23;
                return 64618;  //c 2
            case 24:
                key = 24;
                return 64564;  //b 1
            case 25:
                key = 25;
                return 64506;  //b_b 1
            case 26:
                key = 26;
                return 64445;  //a 1
            case 27:
                key = 27;
                return 64380;  //a_b 1
            case 28:
                key = 28;
                return 64312;  //g 1
            case 29:
                key = 29;
                return 64239;  //g_b 1
            case 30:
                key = 30;
                return 64161;  //f 1
            case 31:
                key = 31;
                return 64080;  //e 1
            case 32:
                key = 32;
                return 63993;  //e_b 1
            case 33:
                key = 33;
                return 63902;  //d 1
            case 34:
                key = 34;
                return 63804;  //d_b 1
            case 35:
                key = 35;
                return 63701;  //c 1
            default:
                break;
        }
        return 0;
    }

    private void setEditMode(int mode_num) {
        this.edit_mode = mode_num;
    }


}


package ubc.aacjhy.realbot;

import processing.core.PApplet;
import processing.core.PVector;

public class Button {
    private PApplet p;
    private Window window;
    private Function_Matrix function_matrix;

    private String label;

    private PVector position;
    private PVector dimension;

    private boolean pressed = false;

    private boolean stroke_flag = true; //enables stroke
    private int s_w = 2;                //stroke weight+
    private PVector stroke_c = new PVector(200, 200, 200);

    private PVector fill_c = new PVector(100, 100, 100);
    private PVector fill_c_pressed = new PVector(130, 130, 130);

    public Button(PApplet p, Window win, Function_Matrix f_m, String l, int x, int y, int w, int h) {
        this.p = p;
        this.window = win;
        this.function_matrix = f_m;

        label = l;

        position = new PVector(x, y);
        dimension = new PVector(w, h);
    }

    public void render() {

        if (stroke_flag) {
            p.strokeWeight(s_w);
            p.stroke(stroke_c.x, stroke_c. y, stroke_c.z);
        } else {
            p.noStroke();
        }

        if (isPressed()) {
            p.strokeWeight(s_w + 2);
            p.fill(fill_c_pressed.x, fill_c_pressed.y, fill_c_pressed.z);
        } else {
            p.strokeWeight(s_w);
            p.fill(fill_c.x, fill_c.y, fill_c.z);
        }

        p.rect(window.getX() + position.x, window.getY() + position.y, dimension.x, dimension.y);
        p.fill(stroke_c.x, stroke_c.y, stroke_c.z);
        p.text(label, window.getX() + position.x, window.getY() + position.y);
    }

    public String getLabel() {
        return label;
    }

    public void update() {

    }

    public int getX() {
        return (int)position.x;
    }

    public int getW() {
        return (int)dimension.x;
    }

    public int getY() {
        return (int)position.y;
    }

    public int getH() {
        return (int)dimension.y;
    }

    public boolean isPressed() {
        return pressed;
    }

    public void pressed() {
        pressed = true;
    }

    public void released() {
        pressed = false;
    }
}

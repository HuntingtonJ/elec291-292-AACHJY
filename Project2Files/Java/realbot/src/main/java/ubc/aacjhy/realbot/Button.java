package ubc.aacjhy.realbot;

import processing.core.PApplet;
import processing.core.PVector;

public class Button {
    private PApplet p;
    private Window window;

    private String label;

    private PVector position;
    private PVector dimension;

    private boolean stroke_flag = true; //enables stroke
    private int s_w = 2;                //stroke weight+
    private PVector stroke_c = new PVector(200, 200, 200);

    private PVector fill_c = new PVector(100, 100, 100);

    public Button(PApplet p, Window win, String l, int x, int y, int w, int h) {
        this.p = p;
        window = win;

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

        p.fill(fill_c.x, fill_c.y, fill_c.z);

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

    public void pressed() {
        
    }
}

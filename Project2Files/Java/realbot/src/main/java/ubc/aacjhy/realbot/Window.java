package ubc.aacjhy.realbot;

import processing.core.PApplet;
import processing.core.PVector;

import java.util.ArrayList;
import java.util.Arrays;

public class Window {
    protected PApplet p;

    private String type;

    private PVector position;
    private PVector dimension;

    private int bezel_width = 6;

    ArrayList<Button> buttons;

    private PVector base_color = new PVector(100, 100, 100);
    private PVector bezel_color = new PVector(200, 200, 200);

    public Window(PApplet p, String type,  int x, int y, int w, int h) {
        this.p = p;

        this.type = type;

        this.position = new PVector(x,y);
        this.dimension = new PVector(w,h);

        buttons = new ArrayList<Button>();
    }

    public void render() {
        render_base();
    }

    protected void render_base() {
        p.noStroke();

        //Draw Bezel
        p.fill(bezel_color.x, bezel_color.y, bezel_color.z);
        p.rect(position.x, position.y, dimension.x, dimension.y);

        //Draw Window
        p.fill(base_color.x, base_color.y, base_color.z);
        p.rect(position.x + bezel_width, position.y + bezel_width, dimension.x - bezel_width*2, dimension.y - bezel_width*2);
    }

    protected void render_buttons() {
        if (buttons.size() > 0) {
            for (Button button : buttons) {
                button.render();
            }
        }
    }

    protected void updateValues() {

    }

    public PVector getPosition() {
        return position;
    }

    public int getFullX() {
        return (int)position.x;
    }

    public int getFullY() {
        return (int)position.y;
    }

    public void setFullX(int x) {
        position.x = x;
    };

    public void setFullY(int y) {
        position.y = y;
    }

    public int getX() {
        return (int)position.x + bezel_width;
    }

    public int getY() {
        return (int)position.y + bezel_width;
    }

    public int getFullWidth() {
        return (int)this.dimension.x;
    }

    public int getFullHeight() {
        return (int)this.dimension.y;
    }

    public void setFullWidth(int w) {
        this.dimension.x = w;
    }

    public void setFullHeight(int h) {
        this.dimension.y = h;
    }

    public int getWidth() {
        return (int)this.dimension.x - 2*bezel_width;
    }

    public int getHeight() {
        return (int)this.dimension.y - 2*bezel_width;
    }

    public int getBezelWidth() {
        return bezel_width;
    }

    public void mousePressedWindow() {

    }

    public void mouseReleasedWindow() {

    }

    public void addButton(String label, int x, int y, int width, int height) {
        buttons.add(new Button(p, this, label, x, y, width, height));
    }

    public void updateButtons() {
        if (buttons.size() > 0) {
            for (Button button : buttons ) {
                button.update();
            }
        }
    }

    public Button getButtonByLabel(String l) {
        if (buttons.size() > 0) {
            for (Button but : buttons) {
                if (l.equals(but.getLabel())) {
                    return but;
                }
            }
        }
        return null;
    }

    public String getType() {
        return type;
    }
}


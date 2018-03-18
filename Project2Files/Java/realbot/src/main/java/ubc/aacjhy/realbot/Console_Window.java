package ubc.aacjhy.realbot;

import processing.core.PApplet;
import processing.core.PVector;
import processing.serial.Serial;

import java.util.ArrayList;

public class Console_Window extends Window {
    private Serial myPort;

    private String outString = "";

    private int unit_height = 20;
    private int unit_width = 8;

    PVector input_line_color = new PVector(20, 20, 20);
    PVector text_color = new PVector(255, 255, 255);
    PVector log_text_color = new PVector(150, 150, 150);

    private ArrayList<String> lines;
    private int cursor = 0;

    public Console_Window(PApplet p, Serial myPort, int x, int y, int w, int h) {
        super(p, x, y, w, h);

        this.myPort = myPort;

        lines = new ArrayList<String>();
        addLine("Console connected");
    }

    @Override
    public void render() {
        render_base();
        renderInput();
        renderLines();
    }

    private void renderLines() {
        p.noStroke();
        p.fill(0);
        p.rect(getX(), getY(), getWidth(), getHeight() - unit_height);

        if (lines.size() > 0) {
            p.fill(log_text_color.x, log_text_color.y, log_text_color.z);
            int i = lines.size();
            for (; i > 0; i--) {
                //renderLine(i);
                if (!(getY() + getHeight() - unit_height - 5 - i * unit_height < getHeight() + unit_height - 5)) {
                    p.text(lines.get(lines.size() - i), getX() + 10, getY() + getHeight() - unit_height - 5 - i * unit_height);
                }
            }
        }
    }

    private void renderLine(int i) {
        for (int j = 0; j < lines.get(i).length(); i++) {
            p.text(lines.get(i).charAt(j), getX() + 10 + j*unit_width, getY() + getHeight() - 5 - i*unit_height);
        }
    }

    private void renderInput() {
        p.noStroke();
        p.fill(input_line_color.x, input_line_color.y, input_line_color.z);
        p.rect(getX(), getY() + getHeight() - unit_height, getWidth(), unit_height);

        p.fill(text_color.x, text_color.y, text_color.z);
        for (int i = 0; i < outString.length(); i++) {
            char c = outString.charAt(i);
            p.text(c, getX() + 10 + i*unit_width, getY() + getHeight() - unit_height );
        }

        if (cursor++ > 50) {
            p.text("_", getX() + 10 + outString.length() * unit_width, getY() + getHeight() - unit_height);
        }

        if (cursor == 99) {
            cursor = 0;
        }
    }

    public void sendOutString() {
        outString += "\n";
        this.myPort.write(outString);
        outString = "";
    }

    public void appendOutString(char c) {
        outString += Character.toString(Character.toLowerCase(c));
    }


    public void addLine(String inString) {
        lines.add(inString);
    }
}

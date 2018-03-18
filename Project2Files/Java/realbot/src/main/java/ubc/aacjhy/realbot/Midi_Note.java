package ubc.aacjhy.realbot;

public class Midi_Note {
    int start;
    int length;

    int value;

    public Midi_Note(int start, int length, int value) {
        this.start = start;
        this.length = length;
        this.value = value;
    }

    public void setLength(int l) {
        this.length = l;
    }
}

package assets.libs;

public class InputHolder {

    public final byte key;
    public final byte state;
    public static byte KEY_RELEASED = 0x01; 
    public static byte KEY_PRESSED = 0x00; 

    public InputHolder(byte key, byte state) {
        this.key = key;
        this.state = state;
    }
}

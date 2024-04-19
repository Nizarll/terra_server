package assets.libs;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

public abstract class KeyHandler implements KeyListener {
    public void keyTyped(KeyEvent e) {};
    public abstract void keyPressed(KeyEvent e);
    public abstract void keyReleased(KeyEvent e);
}
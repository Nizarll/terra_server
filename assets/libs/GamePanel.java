package assets.libs;

import java.awt.Graphics;

import javax.swing.JPanel;

public abstract class GamePanel extends JPanel {
    private Thread game_thread;
    private Thread render_thread;
    public GamePanel() {
        this.game_thread = new Thread(new Runnable() {
            @Override
            public void run() {
                for (;;) {
                    loop();
                }
            }
        });
        this.render_thread = new Thread(new Runnable() {
            @Override
            public void run() {
                for (;;) {
                    repaint();
                    try {
                        Thread.sleep(10);
                    } catch(Exception e) {}
                }
            }
        });
        this.game_thread.start();
        this.render_thread.start();
    }
    @Override
    public void paintComponent(Graphics g) {
        super.paintComponent(g);
        render(g);
    }
    public abstract void loop();
    public abstract void render(Graphics g);
}
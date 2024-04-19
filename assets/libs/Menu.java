package assets.libs;

import java.awt.Color;
import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;
import java.io.File;
import java.util.concurrent.ExecutionException;
import java.util.function.Consumer;

import javax.swing.Timer;
import javax.imageio.ImageIO;
import javax.swing.JFrame;
import javax.swing.JPanel;

public class Menu extends JPanel {

    private int HEIGHT = (int) (126 * .6);
    private int WIDTH = (int) (1135 * .6);
    private int DISPLACEMENT = 2;
    private int SPEED = 4;

    public final String PROJECT_PATH = new File("").getAbsolutePath();
    public final String TITLE_PATH = PROJECT_PATH + "\\assets\\resources\\title.png";

    public static Image title;
    private double y = 0;
    private double s = 0;
    private Vector2 position;
    private Vector2 size = new Vector2(1, 1);
    public double easeInOutQuad(double x) {
        return (x < 0.5) ? 2 * x * x : 1 - Math.pow(-2 * x + 2, 2) / 2;
    }
    private Menu menu;
    public Menu(JFrame frame, Consumer action) {
        this.menu = this;
        try {
            System.out.println(TITLE_PATH);
            title = ImageIO.read(new File(TITLE_PATH));
        } catch (Exception e) {
            e.printStackTrace();
        }
        this.addMouseListener(new MouseAdapter() {
           @Override
           public void mousePressed(MouseEvent e) {
            Thread t = new Thread(new Runnable(){
                @Override
                public void run() {
                    s = .25;
                    try {Thread.sleep(100);
                    s = 0;
                    Thread.sleep(100);
                    } catch (Exception e){}
                    frame.remove(menu);
                    action.accept(null);
                }
            });
            t.start();
           } 
        });
        this.addMouseMotionListener(new MouseMotionAdapter() {
            private double i = 0;
            @Override
            public void mouseMoved(MouseEvent e) {
                if (Math.abs(e.getX() - position.get_x() - WIDTH / 2) < 500
                        && Math.abs(e.getY() - position.get_y()) < 120) s = .1;
                else s = 0;
                System.out.println("mouse pos : magn" + Math.abs(e.getX() - position.get_x()));
            }
        });
        this.setSize((int) (.4 * getWidth()), (int) (.4 * getHeight()));
        this.setBackground(new Color(255, 255, 255));
        Thread curr = new Thread(new Runnable() {
            boolean going_up = false;
            private double i = 0;

            @Override
            public void run() {
                while (true) {
                    if (going_up) {
                        if (i < 1.0d) {
                            i = i < 1.0d ? i + SPEED * .001d : 1;
                            y = -10 * DISPLACEMENT + 20 * DISPLACEMENT * easeInOutQuad(i);
                        } else {
                            going_up = false;
                            i = 1.0;
                        }
                    } else {
                        if (i > .0d) {
                            i = i > 0.0d ? i - SPEED * .001d : 0;
                            y = 10 * DISPLACEMENT - 20 * DISPLACEMENT * (1 - easeInOutQuad(i));
                        } else {
                            going_up = true;
                            i = 0.0;
                        }
                    }
                    repaint();
                    try {
                        Thread.sleep(10);
                    } catch (Exception e) {
                    }
                    ;
                }
            }
        });
        curr.start();
        this.position = new Vector2(getWidth() / 2 - WIDTH / 2, getHeight() / 2);
        paint(getGraphics());
    }

    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        position.set_value(Vector2.lerp(position,
                new Vector2((int) (getWidth() / 2 - WIDTH / 2.0f),
                        (int) (getHeight() / 2 + this.y)),
                .3f));
        size.set_value(Vector2.lerp(size,
                    new Vector2((int) (WIDTH + s * WIDTH),
                    (int) (HEIGHT + s * HEIGHT)),
                .3f));
        if (title != null)
            g.drawImage(title,
                    position.get_x(),
                    position.get_y(),
                    size.get_x(),
                    size.get_y(),
                    getFocusCycleRootAncestor());
    }
}
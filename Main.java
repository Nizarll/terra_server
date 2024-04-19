
import java.awt.Graphics;
import java.awt.event.KeyEvent;
import java.io.File;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetSocketAddress;
import java.net.SocketException;

import assets.libs.Window;
import assets.libs.Entity;
import assets.libs.InputHolder;
import assets.libs.KeyHandler;
import assets.libs.Packet;
import assets.libs.GamePanel;
import assets.libs.ReceivePacket;
import assets.libs.SendPacket;
import assets.libs.Vector2;

public class Main {

    public static String SERVER_IP = "172.24.22.138";
    public static int SERVER_PORT = 8080;

    public static boolean has_connected = false;
    public static boolean has_asked = false;
    public static Entity player = null;

    public static void handle_packet(ReceivePacket p) {
        byte type = p.get_type();
        System.out.println("type is : " + type);
        if (((Object) type) == null)
            return;
        if (type == Packet.ALLOW_CON) {
            player = new Entity(p.holder.getData()[1], new Vector2(0, 0));
            return;
        }
        if (type == Packet.STATE) {
            // byte state = p.holder.getData()[1];
            byte uid = (byte) ((long) (p.holder.getData()[2] & 0xffffffffL));
            // byte dir = p.holder.getData()[3];
            Vector2 pos = new Vector2(((p.holder.getData()[4] & 0xFF) | ((p.holder.getData()[5] & 0xFF) << 8)),
                    ((p.holder.getData()[6] & 0xFF) | ((p.holder.getData()[7] & 0xFF) << 8)));

            if (player != null && player.uid == uid) {
                player.set_position(pos);
                System.out.println("position is : " + pos.toString());
            }
            return; // ???
        }
    }

    public static void request_conn(DatagramSocket socket, InetSocketAddress address) throws Exception {
        byte[] buffer = new byte[1];
        buffer[0] = Packet.DEMAND_CON;
        try {
            socket.setSoTimeout(4000);
        } catch (Exception e) {
            throw new Exception("Could not set the socket timeout");
        }
        DatagramPacket conn = new DatagramPacket(buffer, buffer.length, address);
        ReceivePacket p = new ReceivePacket(socket, 1024);
        while (!has_connected) {
            try {
                socket.send(conn);
                System.out.println("awaiting for connection!");
                p.receive();
                handle_packet(p);
                System.out.println("Successfully connected\n\tpacket received : " + p.holder.getData()[0]);
                has_connected = true;
            } catch (IOException e) {
                System.out.println("packet time out");
            }
        }
    }

    public static void handle_exit(Runtime runtime, DatagramSocket socket, InetSocketAddress address) {
        runtime.addShutdownHook(new Thread() {
            @Override
            public void run() {
                byte[] buff = new byte[1];
                buff[0] = Packet.DEMAND_DISCON;
                DatagramPacket _conn = new DatagramPacket(buff, buff.length, address);
                try {
                    socket.send(_conn);
                } catch (IOException e) {
                    System.out.println("Could not log out of server");
                }
            }
        });
    }

    public static void handle_keypressed(DatagramSocket socket, InetSocketAddress address, KeyEvent event) {
        SendPacket packet = new SendPacket(socket,
                address,
                Packet.CLIENT_INPUT,
                (Object) (new InputHolder((byte) event.getKeyCode(), InputHolder.KEY_PRESSED)));
        try {
            packet.send();
        } catch (Exception e) {
            System.out.println("ERROR : THROWN PACKAGE !");
        }
    }

    public static void handle_keyreleased(DatagramSocket socket, InetSocketAddress address, KeyEvent event) {
        SendPacket packet = new SendPacket(socket,
                address,
                Packet.CLIENT_INPUT,
                (Object) new InputHolder((byte) event.getKeyCode(), InputHolder.KEY_RELEASED));
        try {
            packet.send();
        } catch (Exception e) {
            System.out.println("ERROR : THROWN PACKAGE !");
        }

    }

    public static void main(String[] args) throws SocketException, Exception {
        DatagramSocket socket = new DatagramSocket();
        InetSocketAddress address = new InetSocketAddress(SERVER_IP, SERVER_PORT);
        request_conn(socket, address);
        GamePanel game_panel = new GamePanel() {
            @Override
            public void loop() {
                ReceivePacket packet = new ReceivePacket(socket, 256);
                try {
                    packet.receive();
                    handle_packet(packet);
                } catch (Exception e) {
                    e.printStackTrace();
                    // System.out.println("Could not receive server packet !");
                }
            }

            @Override
            public void render(Graphics g) {
                if (player != null) {
                    g.drawRect(
                            player.get_position().get_x() - 15,
                            this.getHeight() / +player.get_position().get_y() - 15,
                            30,
                            30);
                }
            }
        };
        Window window = new Window(game_panel);
        window.add_keylistener(new KeyHandler() {
            @Override
            public void keyPressed(KeyEvent e) {
                handle_keypressed(socket, address, e);
            }

            @Override
            public void keyReleased(KeyEvent e) {
                handle_keyreleased(socket, address, e);
            }
        });
        window.build();
        Runtime runtime = Runtime.getRuntime();
        handle_exit(runtime, socket, address);
        System.out.println("PACKET IS : " + Packet.asString(Packet.ALLOW_CON));
        System.out.println("class dir is " + new File("").getAbsolutePath());
    }
}
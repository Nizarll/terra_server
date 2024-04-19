
import java.awt.Graphics;
import java.awt.event.KeyEvent;
import java.io.File;
import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetSocketAddress;
import java.net.SocketException;
import java.util.HashMap;

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
    public static HashMap<Byte, Entity> entites = new HashMap<>();
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
            byte uid = (byte) ((long) (p.holder.getData()[2] & 0xffffffffL));
            Vector2 pos = new Vector2(((p.holder.getData()[4] & 0xFF) | ((p.holder.getData()[5] & 0xFF) << 8)),
                    ((p.holder.getData()[6] & 0xFF) | ((p.holder.getData()[7] & 0xFF) << 8)));
            if (player == null) return;
            if (player.uid == uid) {
                System.err.println("INFO : PLAYER STATE");
                player.set_position(pos);
            } else {
                System.err.println("INFO : OTHER PLAYER STATE");
                if (entites.get((Byte)uid) != null) {
                    entites.get((Byte)uid).set_position(pos);
                    return;
                }
                entites.put((Byte)uid, new Entity(uid, pos));
            }
            return;
        }
    }

    public static void request_conn(DatagramSocket socket, InetSocketAddress address) throws Exception {
        byte[] buffer = new byte[1];
        buffer[0] = Packet.DEMAND_CON;
        try {
            socket.setSoTimeout(1);
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
                try {
                    Thread.sleep(400);
                } catch (Exception e) {}
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
                } catch (Exception e) {}
            }

            @Override
            public void render(Graphics g) {
                if (player != null) {
                    if (player.last == null) {
                        player.last = new Vector2(
                            player.get_position().get_x() - 15,
                            player.get_position().get_y() - 15 + 400);
                    g.drawRect(
                            player.get_position().get_x() - 15,
                            player.get_position().get_y() - 15 + 400,
                            30,
                            30);
                    } else {
                    Vector2 pos = Vector2.lerp(player.last,
                        new Vector2(
                            player.get_position().get_x() - 15,
                            player.get_position().get_y() - 15 + 400
                    ), .3f);
                    g.drawRect(
                            pos.get_x(),
                            pos.get_y(),
                            30,
                            30);
                            player.last = pos;
                    }
                }
                entites.forEach((_uid, entity) -> {
                        if (entity.last == null) {
                            g.drawRect(
                                entity.get_position().get_x() - 15,
                                entity.get_position().get_y() - 15 + 400,
                                30,
                                30);
                            entity.last = new Vector2(
                                                    entity.get_position().get_x() - 15,
                                                    entity.get_position().get_y() - 15 + 400);
                } else {
                         g.drawRect(
                            entity.last.get_x(),
                            entity.last.get_y(),
                            30,
                            30);
                            entity.last = Vector2.lerp(entity.last,
                                                    new Vector2(entity.get_position().get_x() - 15,
                                                       entity.get_position().get_y() - 15 + 400),
                                                       .3f);
                        }
                });
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
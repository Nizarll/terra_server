package assets.libs;

import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetSocketAddress;

public abstract class Packet {

    public final static byte DISALLOW_CON = 0x00;
    public final static byte ALLOW_CON = 0x01;
    public final static byte DEMAND_CON = 0x02;
    public final static byte DEMAND_DISCON = 0x03;
    public final static byte DISCONNECT = 0x04;
    public final static byte CONNECT = 0x05;
    public final static byte STATE = 0x06;
    public final static byte CLIENT_INPUT = 0x07;

    public DatagramPacket holder;
    protected byte type;
    protected DatagramSocket socket;
    protected Object payload;
    protected InetSocketAddress address;
    protected byte[] buffer;

    public byte get_type() {
        return this.type;
    }

    public Packet(DatagramSocket socket, int length) {
        this.socket = socket;
        this.buffer = new byte[length];
        this.holder = new DatagramPacket(buffer, length);
   }

   public Packet(DatagramSocket socket, InetSocketAddress address, byte type, Object payload) {
        this.buffer = new byte[512];
        this.holder = new DatagramPacket(buffer, 512);
        this.type = type;
        this.payload = payload;
        this.address = address;
        this.socket = socket;
   }

    public static String asString(byte type) {
        if (type == ALLOW_CON) return "ALLOW_CON";
        if (type == DEMAND_CON) return "DEMAND_CON";
        if (type == DEMAND_DISCON) return "DEMAND_DICON";
        if (type == DISALLOW_CON) return "ALLOW_CON";
        if (type == CONNECT) return "CONNECT";
        if (type == DISCONNECT) return "DISCONNECT";
        if (type == STATE) return "STATE";
        return null;
    }
}
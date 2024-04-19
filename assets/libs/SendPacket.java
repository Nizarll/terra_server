package assets.libs;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetSocketAddress;

public class SendPacket extends Packet {

    public SendPacket(DatagramSocket socket, InetSocketAddress address, byte type, Object payload) {
        super(socket, address, type, payload);
    }

    private byte[] serialize() {
        switch (this.type) {
            case Packet.ALLOW_CON:
                return new byte[] {
                };
            case Packet.CONNECT:
                return new byte[] {
                };
            case Packet.DISCONNECT:
                return new byte[] {

                };
            case Packet.CLIENT_INPUT:
                InputHolder holder = (InputHolder) this.payload;
                return new byte[] {
                        Packet.CLIENT_INPUT,
                        holder.key,
                        holder.state
                };
            default:
                System.out.println("ERROR: UNHANDLED CLIENT PACKET");
                break;
        }
        ;
        return null;
    }

    public void send() throws IOException {
        if (this.serialize() == null)
            return;
        this.socket.send(
                new DatagramPacket(this.serialize(),
                        this.serialize().length,
                        this.address));
    }

}

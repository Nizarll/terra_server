package assets.libs;

import java.io.IOException;
import java.net.DatagramSocket;

public class ReceivePacket extends Packet {
    public ReceivePacket(DatagramSocket socket, int length) {
        super(socket, length);
    }

    public void receive() throws IOException {
        this.socket.receive(this.holder);
        this.type = this.buffer[0];
    }
}

package assets.libs;

public class Entity {

    private Vector2 position;
    public final byte uid;
    public Vector2 last = null;
    private long last_state;

    public Entity(byte uid, Vector2 position) {
        this.uid = uid;
        this.position = position;
        this.last_state = System.currentTimeMillis();
    }

    public void set_position(Vector2 position) {
        this.position = position;
        this.last_state = System.currentTimeMillis();
    };

    public Vector2 get_position() {
        return this.position;
    };
}

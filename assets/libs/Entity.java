package assets.libs;

public class Entity {

    private Vector2 position;
    public final byte uid;

    public Entity(byte uid, Vector2 position) {
        this.uid = uid;
        this.position = position;
    }

    public void set_position(Vector2 position) {
        this.position = position;
    };

    public Vector2 get_position() {
        return this.position;
    };
}

package assets.libs;

public class Vector2 {
    private int x;
    private int y;

    public Vector2(int x, int y) {
        this.x = x;
        this.y = y;
    };

    public int get_x() {
        return this.x;
    }

    public int get_y() {
        return this.y;
    }

    public void set_value(Vector2 value) {
        this.x = value.x;
        this.y = value.y;
    };

    @Override
    public String toString() {
        return "Vector2 { x : " + this.x + ", y : " + this.y + " }";
    };
}

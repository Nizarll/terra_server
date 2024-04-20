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

    public long magnitude() {
       return (long)Math.sqrt(Math.pow((double)this.get_x(), 2) + Math.pow((double)this.get_y(), 2));
    }

    public static Vector2 lerp(Vector2 a, Vector2 b, float t) {
        return new Vector2(
            (int)(a.get_x() + t * (b.get_x() - a.get_x())),
            (int)(a.get_y() + t * (b.get_y() - a.get_y()))
        );
    };
    @Override
    public String toString() {
        return "Vector2 { x : " + this.x + ", y : " + this.y + " }";
    };
}

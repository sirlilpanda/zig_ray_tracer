pub fn Vec3(comptime T: type) type {
    return struct {
        const Self = @This();
        x: T,
        y: T,
        z: T,

        pub fn init(x: T, y: T, z: T) Self {
            return Self{ .x = x, .y = y, .z = z };
        }

        pub fn max(a: Self) T {
            if ((a.x >= a.z) and (a.x >= a.y)) return a.x;
            if ((a.z >= a.x) and (a.z >= a.y)) return a.z;
            if ((a.y >= a.z) and (a.y >= a.x)) return a.y;
        }

        pub fn min(a: Self) T {
            if ((a.x <= a.z) and (a.x <= a.y)) return a.x;
            if ((a.z <= a.x) and (a.z <= a.y)) return a.z;
            if ((a.y <= a.z) and (a.y <= a.x)) return a.y;
        }

        pub fn dot(a: Self, b: Self) T {
            return a.x * b.x + a.y * b.y + a.z * b.z;
        }

        pub fn sum(a: Self) T {
            return a.x + a.y + a.z;
        }

        pub fn len(a: Self) T {
            return @sqrt(a.x * a.x + a.y * a.y + a.z * a.z);
        }

        pub fn norm(a: Self) Self {
            const den: T = len(a);
            return div(a, den);
        }

        pub fn add(a: Self, b: Self) Self {
            return Self{
                .x = a.x + b.x,
                .y = a.y + b.y,
                .z = a.z + b.z,
            };
        }

        pub fn sub(a: Self, b: Self) Self {
            return Self{
                .x = a.x - b.x,
                .y = a.y - b.y,
                .z = a.z - b.z,
            };
        }

        pub fn mul(a: Self, b: Self) Self {
            return Self{
                .x = a.x * b.x,
                .y = a.y * b.y,
                .z = a.z * b.z,
            };
        }

        pub fn div(a: Self, b: Self) Self {
            return Self{
                .x = a.x / b.x,
                .y = a.y / b.y,
                .z = a.z / b.z,
            };
        }

        pub fn scale(a: Self, b: T) Self {
            return Self{
                .x = a.x * b,
                .y = a.y * b,
                .z = a.z * b,
            };
        }

        pub fn cross(a: Self, b: Self) Self {
            return Self{
                .x = a.y * b.z - a.z * b.y,
                .y = a.z * b.x - a.x * b.z,
                .z = a.x * b.y - a.y * b.x,
            };
        }

        pub fn eq(a: Self, b: Self) bool {
            return if (a.x == b.x and
                a.y == b.y and
                a.z == b.z) true else false;
        }
    };
}

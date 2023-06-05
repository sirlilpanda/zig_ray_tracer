const VecError = error{
    invalidVec,
};

pub fn Vec3(comptime T: type) type {
    return packed struct {
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
            return a.scale(1 / den);
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

        // https://graphics.stanford.edu/courses/cs148-10-summer/docs/2006--degreve--reflection_refraction.pdf

        pub fn reflect(a: Self, b: Self) Self {
            const cosI = -a.dot(b);
            return b.add(a.scale(2 * cosI));
        }

        pub fn refract(a: Self, b: Self, n1: T, n2: T) VecError!Self {
            const n = n1 / n2;
            const cosI = -a.dot(b);
            const sinT2 = n * n * (1 - cosI * cosI);
            if (sinT2 > 1) return VecError.invalidVec;
            const cosT = @sqrt(1 - sinT2);
            return b.scale(n).add(a.scale(n * (cosI - cosT)));
        }

        // used for water or some shit, if its further away then its more refective or something like that
        pub fn reflectance(a: Self, b: Self, n1: T, n2: T) T {
            const n = n1 / n2;
            const cosI = -a.dot(b);
            const sinT2 = n * n * (1 - cosI * cosI);
            if (sinT2 > 1) return 1;
            const cosT = @sqrt(1 - sinT2);
            const r0rth = (n1 * cosI - n2 * cosT) / (n1 * cosI - n2 * cosT);
            const rPar = (n2 * cosI - n1 * cosT) / (n2 * cosI - n1 * cosT);
            return (r0rth * r0rth + rPar * rPar) / 2;
        }
    };
}

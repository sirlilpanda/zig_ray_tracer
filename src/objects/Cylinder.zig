const types = @import("../types.zig");
const Vec3f32 = types.Vec3f32;

pub const Cylinder = struct {
    center: Vec3f32,
    raduis: f32,
    height: f32,

    pub fn init(center: Vec3f32, raduis: f32, height: f32) Cylinder {
        return Cylinder{
            .center = center,
            .raduis = raduis,
            .height = height,
        };
    }

    pub fn intersect(s: Cylinder, p0: Vec3f32, dir: Vec3f32) f32 {
        // need to implement
        const vdif = p0.sub(s.center); //Vector s (see Slide 28)
        const b: f32 = dir.dot(vdif);
        const len: f32 = vdif.len();
        const c: f32 = len * len - s.raduis * s.raduis;
        const delta: f32 = b * b - c;

        if (delta < 0.001) return -1; //includes zero and negative values

        const t1: f32 = -b - @sqrt(delta);
        const t2: f32 = -b + @sqrt(delta);

        return if (t1 < 0) if (t2 > 0) t2 else -1 else return t1;
    }

    pub fn normal(s: Cylinder, point: Vec3f32) Vec3f32 {
        return point.sub(s.center).norm();
    }
};

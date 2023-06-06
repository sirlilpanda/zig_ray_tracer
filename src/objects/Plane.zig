const types = @import("../types.zig");
const Vec3f32 = types.Vec3f32;
const std = @import("std");

pub const Plane = struct {
    a: Vec3f32,
    b: Vec3f32,
    c: Vec3f32,
    d: Vec3f32,

    pub fn init(a: Vec3f32, b: Vec3f32, c: Vec3f32, d: Vec3f32) Plane {
        return Plane{
            .a = a,
            .b = b,
            .c = c,
            .d = d,
        };
    }

    pub fn intersect(plane: Plane, p0: Vec3f32, dir: Vec3f32) f32 {
        const n: Vec3f32 = p0.norm();
        const vdif: Vec3f32 = plane.a.sub(p0);
        const d_dot_n: f32 = dir.dot(n);
        if (@fabs(d_dot_n) < 1.e-4) return -1; //Parallel ray
        const t = vdif.dot(n) / d_dot_n;
        if (t < 0) return -1;
        const q: Vec3f32 = p0.add(dir.scale(t)); //Point of intersection
        if (plane.isInside(q)) return t; //Inside the plane
        return -1; //Outside
    }

    fn isInside(plane: Plane, point: Vec3f32) bool {
        const n: Vec3f32 = point.norm(); //Normal vector at the point of intersection
        const ua: Vec3f32 = plane.b.sub(plane.a);
        const ub: Vec3f32 = plane.c.sub(plane.b);
        const uc: Vec3f32 = plane.d.sub(plane.c);
        const ud: Vec3f32 = plane.a.sub(plane.d);
        const va: Vec3f32 = point.sub(plane.a);
        const vb: Vec3f32 = point.sub(plane.b);
        const vc: Vec3f32 = point.sub(plane.c);
        const vd: Vec3f32 = point.sub(plane.d);
        const ka: f32 = ua.cross(va).dot(n);
        const kb: f32 = ub.cross(vb).dot(n);
        const kc: f32 = uc.cross(vc).dot(n);
        const kd: f32 = ud.cross(vd).dot(n);
        if (ka > 0 and kb > 0 and kc > 0 and kd > 0) return true;
        if (ka < 0 and kb < 0 and kc < 0 and kd < 0) return true;
        return false;
    }

    pub fn normal(plane: Plane) Vec3f32 {
        const v1: Vec3f32 = plane.c.sub(plane.b);
        const v2: Vec3f32 = plane.a.sub(plane.b);
        const n: Vec3f32 = v1.cross(v2);
        return n.norm();
    }
};

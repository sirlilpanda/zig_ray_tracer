const types = @import("../types.zig");
const Vec3f32 = types.Vec3f32;
const std = @import("std");
pub const Cylinder = struct {
    center: Vec3f32,
    radius: f32,
    height: f32,

    fn a_term(dx: f32, dz: f32) f32 {
        return dx * dx + dz * dz;
    }

    fn b_term(dx: f32, dz: f32, xo: f32, xc: f32, zo: f32, zc: f32) f32 {
        return 2 * (dx * (xo - xc) + dz * (zo - zc));
    }

    fn c_term(xo: f32, xc: f32, zo: f32, zc: f32, r: f32) f32 {
        return ((xo - xc) * (xo - xc)) + ((zo - zc) * (zo - zc)) - r * r;
    }

    pub fn init(center: Vec3f32, radius: f32, height: f32) Cylinder {
        return Cylinder{
            .center = center,
            .radius = radius,
            .height = height,
        };
    }

    //need to make cap
    pub fn intersect(cylinder: Cylinder, p0: Vec3f32, dir: Vec3f32) f32 {
        const a: f32 = a_term(dir.x, dir.z);
        const b: f32 = b_term(dir.x, dir.z, p0.x, cylinder.center.x, p0.z, cylinder.center.z);
        const c: f32 = c_term(p0.x, cylinder.center.x, p0.z, cylinder.center.z, cylinder.radius);

        const det: f32 = b * b - 4 * a * c;

        if (det < 0.001) return -1; //includes zero and negative values

        const t1: f32 = (-b - @sqrt(det)) / (2 * a);
        const t2: f32 = (-b + @sqrt(det)) / (2 * a);
        var temp: Vec3f32 = undefined;

        if (t1 < t2) {
            temp = p0.add(dir.scale(t1));
        } else {
            temp = p0.add(dir.scale(t2));
        }

        if ((temp.y >= cylinder.center.y) and (temp.y <= cylinder.center.y + cylinder.height)) {
            return t1;
        } else if ((temp.y > cylinder.center.y + cylinder.height) and ((p0.y + t2 * dir.y) <= cylinder.center.y + cylinder.height)) {
            //never reaches here find out why
            return t2 - t1;
        }

        // if nothing works then it doesnt intersect
        return -1;
    }

    pub fn normal(cylinder: Cylinder, point: Vec3f32) Vec3f32 {
        var norm: Vec3f32 = point.sub(cylinder.center);
        if (point.y >= cylinder.center.y + cylinder.height) {
            return Vec3f32.init(0, 1, 0);
        }
        norm.y = 0;
        norm = norm.scale(1 / cylinder.radius);
        return norm;
    }
};

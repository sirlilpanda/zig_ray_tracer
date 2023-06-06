const types = @import("types.zig");
const objects = @import("objects/Object.zig");
const std = @import("std");
const Vec3f32 = types.Vec3f32;

const R_step: f32 = 0.005; // so the closest obj is not itself

pub const Hitcheck = struct {
    hit: ?Vec3f32,
    index: ?usize,
    dist: ?f32,
    found: bool,
};

pub const Ray = struct {
    const Self = @This();
    p0: Vec3f32,
    dir: Vec3f32,

    pub fn init(p0: Vec3f32, dir: Vec3f32) Ray {
        return Self{
            .p0 = p0.add(dir.norm().scale(R_step)),
            .dir = dir.norm(),
        };
    }

    pub fn closestPoint(self: Self, objs: [3]objects.Object) Hitcheck {
        var tmin: f32 = 1e+6;
        var found: bool = false;
        var hit: ?Vec3f32 = null;
        var dist: ?f32 = null;
        var closest_object_index: ?usize = null;
        for (objs, 0..) |obj, i| {
            var t = obj.intersect(self.p0, self.dir);
            if (t > 0) {
                if (t < tmin) {
                    hit = self.p0.add(self.dir.scale(t));
                    closest_object_index = i;
                    found = true;
                    dist = t;
                    tmin = t;
                }
            }
        }
        return Hitcheck{
            .hit = hit,
            .dist = dist,
            .index = closest_object_index,
            .found = found,
        };
    }
};

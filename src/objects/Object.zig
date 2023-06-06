const types = @import("../types.zig");
const import_sphere = @import("sphere.zig");
const import_cylinder = @import("Cylinder.zig");
const import_plane = @import("Plane.zig");
const pow = @import("std").math.pow;
const std = @import("std");
const Vec3f32 = types.Vec3f32;
const Colour = types.Colour;

pub const ObjectType = enum {
    sphere,
    plane,
    // cone,
    cylinder,
};

const Objects = union(ObjectType) {
    sphere: import_sphere.Sphere,
    cylinder: import_cylinder.Cylinder,
    plane: import_plane.Plane,
};

pub const Object = struct {
    const Self = @This();
    color: Colour = Colour.init(0, 0, 0),
    isreflectivity: bool = false,
    isrefractivity: bool = false,
    isspecularity: bool = false,
    transparency: bool = false,
    reflection_coeff: f32 = 0,
    refraction_coeff: f32 = 0,
    transparency_coeff: f32 = 0,
    refractive_index: f32 = 0,
    shininess: f32 = 0,
    obj: Objects,

    pub fn init(comptime object: ObjectType, args: anytype) Self {
        const o: Objects = switch (object) {
            .sphere => Objects{ .sphere = import_sphere.Sphere.init(args.center, args.radius) },
            .cylinder => Objects{ .cylinder = import_cylinder.Cylinder.init(args.center, args.radius, args.height) },
            .plane => Objects{ .plane = import_plane.Plane.init(args.a, args.b, args.c, args.d) },
        };
        return Self{
            .color = Colour.init(0, 0, 0),
            .isreflectivity = false,
            .isrefractivity = false,
            .isspecularity = false,
            .transparency = false,
            .reflection_coeff = 0,
            .refraction_coeff = 0,
            .transparency_coeff = 0,
            .refractive_index = 0,
            .shininess = 0,
            .obj = o,
        };
    }

    pub fn normal(o: Self, point: Vec3f32) Vec3f32 {
        return switch (o.obj) {
            .sphere => |s| s.normal(point),
            .cylinder => |c| c.normal(point),
            .plane => |p| p.normal(),
        };
    }
    pub fn intersect(o: Self, center: Vec3f32, dir: Vec3f32) f32 {
        return switch (o.obj) {
            .sphere => |s| s.intersect(center, dir),
            .cylinder => |c| c.intersect(center, dir),
            .plane => |p| p.intersect(center, dir),
        };
    }

    pub fn lighting(o: Object, lightPos: Vec3f32, viewVec: Vec3f32, hit: Vec3f32, ambientTerm: f32) Vec3f32 {
        // diffuseTerm = 0;
        var specularTerm: f32 = 0;
        const lightVec: Vec3f32 = lightPos.sub(hit).norm();
        const lDotn: f32 = lightVec.dot(o.normal(hit));
        if (o.isspecularity) {
            const rDotv = lightVec.scale(-1).reflect(o.normal(hit)).dot(viewVec);
            if (rDotv > 0) specularTerm = pow(f32, rDotv, o.shininess);
        }

        const ambientColour = o.color.scale(ambientTerm);
        const dotColour = o.color.scale(lDotn);
        const specterm = Vec3f32.init(1, 1, 1).scale(specularTerm);

        return ambientColour.add(dotColour).add(specterm);
    }
};

const std = @import("std");
const types = @import("types.zig");
const colourchar = @import("colourChar.zig");
const Iray = @import("Ray.zig");
const vec = @import("Vec3.zig");
const screen = @import("Screen.zig");
const objects = @import("objects/Object.zig");

const Vec3f32 = vec.Vec3(f32);
const Colour = types.Colour;
const Screen = screen.Screen(140, 140);

const background_colour: Colour = Colour.init(0, 0, 0);
const light_pos: Vec3f32 = Vec3f32.init(-50, -50, 0);
const ambient_term: f32 = 0.2;

const plane_dist: f32 = 100;
const max_step = 5;

var scene_objects: [2]objects.Object = undefined;

pub fn trace(ray: Iray.Ray, step: u8) Colour {
    _ = step;
    const cache: Iray.hitNindex = ray.closestPoint(scene_objects);
    if (!cache.found) return background_colour;

    var colour: Colour = scene_objects[cache.index orelse 0].lighting(
        light_pos,
        ray.dir.scale(-1),
        cache.hit orelse std.debug.panic("smt fucked up", .{}),
        ambient_term,
    );
    return colour;
}

pub fn fillScreen(outScreen: Screen) !void {
    var eye_pos: Vec3f32 = Vec3f32.init(0, 0, 0);

    const i_start: i32 = -(@divTrunc(@as(i32, outScreen.height), 2));
    const j_start: i32 = -(@divTrunc(@as(i32, outScreen.width), 2));
    var i: i32 = i_start;
    var j: i32 = j_start;

    while (i < outScreen.height / 2) : (i += 1) {
        while (j < outScreen.width / 2) : (j += 1) {
            var dir: Vec3f32 = Vec3f32.init(
                eye_pos.x + @intToFloat(f32, i),
                eye_pos.x + @intToFloat(f32, j),
                -plane_dist,
            );
            var ray: Iray.Ray = Iray.Ray.init(eye_pos, dir);
            const c: Colour = trace(ray, 0);
            try outScreen.set_pixel(
                @intCast(u16, i + outScreen.width / 2),
                @intCast(u16, j + outScreen.width / 2),
                c,
            );
        }
        j = j_start;
    }
}

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();
    var char_screen: Screen = Screen.init();

    var ball = objects.Object.init(
        objects.ObjectType.sphere,
        .{
            .center = Vec3f32.init(0, 0, -150),
            .radius = 50,
        },
    );
    var ball2 = objects.Object.init(
        objects.ObjectType.sphere,
        .{
            .center = Vec3f32.init(-20, -70, -150),
            .radius = 10,
        },
    );

    ball.color = Colour.init(1, 0, 1);
    ball.shininess = 100;
    ball.isspecularity = true;
    ball2.color = Colour.init(1, 1, 1);

    scene_objects[0] = ball;
    scene_objects[1] = ball2;

    try fillScreen(char_screen);
    try char_screen.print(stdout);
    try bw.flush();
}

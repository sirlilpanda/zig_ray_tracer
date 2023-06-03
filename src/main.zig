const std = @import("std");
const colourchar = @import("colourChar.zig");
const vec = @import("Vec3.zig");

const Vec3f32 = vec.Vec3(f32);
const Vec3u8 = vec.Vec3(u8);

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)

    std.debug.print("{u}\n", .{'⚡'});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.

    const green: Vec3u8 = Vec3u8.init(0, 255, 0);
    const red: Vec3u8 = Vec3u8.init(255, 0, 0);
    const c: colourchar.ColourChar = colourchar.ColourChar.init('▀', green, red);

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try c.print_char(stdout);
    try stdout.print("{u}\n", .{'⚡'});

    try bw.flush(); // don't forget to flush!
}

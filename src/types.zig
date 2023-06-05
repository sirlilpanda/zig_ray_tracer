const vec = @import("Vec3.zig");
const std = @import("std");
pub const Colour = vec.Vec3(f32);
pub const Colouru8 = vec.Vec3(u8);
pub const Vec3f32 = vec.Vec3(f32);

pub fn colourToColouru8(c: Colour) Colouru8 {
    return Colouru8{
        .x = @floatToInt(u8, if (c.x <= 0) 0 else if (c.x * 255 >= 255) 255 else c.x * 255),
        .y = @floatToInt(u8, if (c.y <= 0) 0 else if (c.y * 255 >= 255) 255 else c.y * 255),
        .z = @floatToInt(u8, if (c.z <= 0) 0 else if (c.z * 255 >= 255) 255 else c.z * 255),
    };
}

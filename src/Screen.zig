const colourChar = @import("ColourChar.zig");
const types = @import("types.zig");
const Colour = types.Colour;
const ColourChar = colourChar.ColourChar;
const char: u16 = '▄';

const ScreenError = error{
    pointOutOfBounds,
};

pub fn Screen(comptime h: u16, comptime w: u16) type {
    return struct {
        const Self = @This();
        height: u16 = h,
        width: u16 = w,
        var pixels: [h][w]Colour = undefined;

        pub fn init() Self {
            return Self{ .height = h, .width = w };
        }

        pub fn set_pixel(screen: Self, x: u16, y: u16, color: Colour) ScreenError!void {
            if (x > screen.width or y > screen.height) return ScreenError.pointOutOfBounds;
            pixels[y][x] = color;
        }

        pub fn print(screen: Self, writer: anytype) !void {
            var i: u16 = 0;
            var j: u16 = 0;
            while (i < screen.height / 2) : (i += 1) {
                while (j < screen.width) : (j += 1) {
                    const c: ColourChar = ColourChar.init(
                        char,
                        types.colourToColouru8(pixels[i * 2][j]),
                        types.colourToColouru8(pixels[i * 2 + 1][j]),
                    );
                    try c.print_char(writer);
                }
                j = 0;
                try writer.print("\n", .{});
            }
        }
    };
}

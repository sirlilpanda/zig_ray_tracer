const types = @import("types.zig");
const Colouru8 = types.Colouru8;

pub const ColourChar = struct {
    char: u16,
    colour_bg: Colouru8,
    colour_fg: Colouru8,

    pub fn init(char: u16, colour_bg: Colouru8, colour_fg: Colouru8) ColourChar {
        return ColourChar{ .char = char, .colour_bg = colour_bg, .colour_fg = colour_fg };
    }

    pub fn print_char(c: ColourChar, printer: anytype) !void {
        //"\x1B[38;2;{};{};{}m\x1B[48;2;{};{};{}m"
        try printer.print("\x1B[38;2;{d};{d};{d}m\x1B[48;2;{d};{d};{d}m{u}\x1B[0m", .{ c.colour_fg.x, c.colour_fg.y, c.colour_fg.z, c.colour_bg.x, c.colour_bg.y, c.colour_bg.z, c.char });
    }
};

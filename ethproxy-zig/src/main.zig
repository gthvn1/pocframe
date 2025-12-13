const std = @import("std");
const a = @import("args.zig");

pub fn main() !void {
    const args = a.ReadArgs() orelse {
        std.debug.print("Usage: ethproxy <peer_iface> <socket>\n", .{});
        std.process.exit(1);
    };

    std.debug.print("Peer Interface: {s}\n", .{args.peer_iface});
    std.debug.print("Socket: {s}\n", .{args.socket});

    // Read user input
    var buffer: [1024]u8 = undefined;
    var stdin_reader = std.fs.File.stdin().reader(&buffer);
    const stdin = &stdin_reader.interface;

    std.debug.print("Ctrl-d to end\n", .{});
    std.debug.print("> ", .{});

    while (stdin.takeDelimiterExclusive('\n')) |r| {
        // need to toss the delimiter explicitly since we're not reading it
        stdin.toss(1);

        std.debug.print("You write <{s}>\n", .{r});
        std.debug.print("> ", .{});
    } else |_| {
        std.debug.print("end", .{});
        std.process.exit(1);
    }
}

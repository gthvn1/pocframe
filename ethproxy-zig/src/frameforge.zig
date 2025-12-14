const std = @import("std");
const posix = std.posix;

pub const FrameForge = struct {
    fd: posix.fd_t,

    pub fn init(path: []const u8) !FrameForge {
        // Connect to frameforge server using Unix domain socket
        // https://medium.com/swlh/getting-started-with-unix-domain-sockets-4472c0db4eb1
        const frameforge_fd = try posix.socket(posix.AF.UNIX, posix.SOCK.STREAM, 0);

        var p: [108]u8 = [_]u8{0} ** 108;
        std.mem.copyForwards(u8, &p, path);

        const frameforge_addr = posix.sockaddr.un{
            .family = posix.AF.UNIX,
            .path = p,
        };

        try posix.connect(frameforge_fd, @ptrCast(&frameforge_addr), @sizeOf(posix.sockaddr.un));

        return .{
            .fd = frameforge_fd,
        };
    }

    pub fn deinit(self: *FrameForge) void {
        posix.close(self.fd);
    }

    // The protocol is to send 4 bytes that are the size of message and then the message
    pub fn send(self: *const FrameForge, msg: []const u8) !void {
        const msg_len: u32 = @intCast(msg.len);
        var header: [4]u8 = undefined;

        std.mem.writeInt(u32, &header, msg_len, .little);
        const header_written = try posix.write(self.fd, &header);
        if (header_written != 4) {
            // TODO: return an error probably...
            std.debug.print("Expected to send 4 bytes but sent {d}\n", .{header_written});
        }

        const msg_written = try posix.write(self.fd, msg);
        if (msg_written != msg_len) {
            // TODO: return an error probably...
            std.debug.print("Expected to send {d} bytes but sent {d}\n", .{ msg_len, msg_written });
        }
    }

    pub fn read(self: *const FrameForge, allocator: std.mem.Allocator) ![]u8 {
        var header: [4]u8 = undefined;
        try self.readExact(&header); // [4]u8 coerces to []u8

        const payload_len = std.mem.readInt(u32, header[0..4], .little);
        // We are not expecting more than 1600 bytes
        if (payload_len > 1600) return error.PayloadTooBig;

        const payload = try allocator.alloc(u8, @intCast(payload_len));
        errdefer allocator.free(payload); // If readExact failed memory will be freed

        try self.readExact(payload);
        return payload;
    }

    // We need to read exactly the expected number of bytes otherwise we will desync.
    // So read until the buffer passed as parameter is filled.
    fn readExact(self: *const FrameForge, buf: []u8) !void {
        var off: usize = 0;

        while (off < buf.len) {
            const n = try posix.read(self.fd, buf[off..]);
            if (n == 0) return error.ConnectionClosed;
            off += n;
        }
    }
};

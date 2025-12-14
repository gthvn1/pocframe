const std = @import("std");
const posix = std.posix;

pub const Veth = struct {
    fd: posix.fd_t,

    pub fn init(name: []const u8) !Veth {
        _ = name;
        @panic("TODO: not yet implemented");
    }

    pub fn deinit(self: *Veth) void {
        posix.close(self.fd);
    }
};

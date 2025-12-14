const std = @import("std");
const posix = std.posix;

// TODO: if we want to remove the C dependency we can probably pass the index
//       as parameter when calling the binary. Or at least, as the network is setup
//       before calling the proxy we can pass the result of `ip -j a` and parse the
//       json to find the index.
pub const Veth = struct {
    fd: posix.fd_t,

    pub fn init(name: [:0]const u8) !Veth {
        // man 7 packet
        const veth_fd = try posix.socket(posix.AF.PACKET, posix.SOCK.STREAM, 0);

        const veth_addr = posix.sockaddr.ll{
            .family = posix.AF.PACKET,
            .protocol = std.os.linux.ETH.P.ALL,
            .ifindex = std.c.if_nametoindex(name),
            .hatype = 0,
            .pkttype = 0,
            .halen = 0,
            .addr = [_]u8{0} ** 8,
        };

        try posix.connect(veth_fd, @ptrCast(&veth_addr), @sizeOf(posix.sockaddr.ll));

        return .{
            .fd = veth_fd,
        };
    }

    pub fn deinit(self: *Veth) void {
        posix.close(self.fd);
    }
};

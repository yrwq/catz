const std = @import("std");

const max_size = 1 * 1024 * 1024;

fn usage() void {
    std.os.exit(1);
}

pub fn main() !void {
    const alloc = std.heap.page_allocator;

    var lines = std.ArrayList([]u8).init(alloc);

    const args = try std.process.argsAlloc(alloc);
    defer alloc.free(args);


    if (args.len <= 1) {
        usage();
    }


    const file = try std.fs.cwd().openFile(args[1], .{});
    defer file.close();
    while (try file.reader().readUntilDelimiterOrEofAlloc(alloc, '\n', max_size)) |line| {
        try lines.append(line);
    }

    for (lines.items) |item|
        std.debug.print("{s}\n", .{item});

}

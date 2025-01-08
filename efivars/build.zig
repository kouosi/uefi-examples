const std = @import("std");

pub fn build(b: *std.Build) void {
    const uefi_target = std.Target.Query{
        .os_tag = .uefi,
        .cpu_arch = .x86_64,
        .abi = .msvc,
    };
    const target = b.standardTargetOptions(.{ .default_target = uefi_target });
    const optimize = b.standardOptimizeOption(.{ .preferred_optimize_mode = .ReleaseSafe });

    const app = b.addExecutable(.{
        .name = "bootx64",
        .root_source_file = b.path("main.zig"),
        .optimize = optimize,
        .target = target,
    });
    b.installArtifact(app);
}

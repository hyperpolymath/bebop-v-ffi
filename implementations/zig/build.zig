// SPDX-License-Identifier: AGPL-3.0-or-later
// SPDX-FileCopyrightText: 2025 Hyperpolymath Contributors
//
// build.zig - Build the Bebop-V-FFI shared library
//
// Usage:
//   zig build              # Debug build
//   zig build -Drelease    # Release build
//   zig build test         # Run tests

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Build the shared library
    const lib = b.addSharedLibrary(.{
        .name = "bebop_v_ffi",
        .root_source_file = b.path("src/bridge.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Also build static library for linking flexibility
    const static_lib = b.addStaticLibrary(.{
        .name = "bebop_v_ffi",
        .root_source_file = b.path("src/bridge.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Install both artifacts
    b.installArtifact(lib);
    b.installArtifact(static_lib);

    // Install the header for consumers
    b.installFile("../../include/bebop_v_ffi.h", "include/bebop_v_ffi.h");

    // Unit tests
    const unit_tests = b.addTest(.{
        .root_source_file = b.path("src/bridge.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}

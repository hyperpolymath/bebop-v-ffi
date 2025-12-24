// SPDX-License-Identifier: AGPL-3.0-or-later
// SPDX-FileCopyrightText: 2025 Hyperpolymath Contributors
//
// bridge.zig - Zig implementation of the Bebop-V-FFI C ABI
//
// This exports C-callable functions matching include/bebop_v_ffi.h.
// No C compiler needed — Zig handles the ABI directly.

const std = @import("std");
const Allocator = std.mem.Allocator;

// -----------------------------------------------------------------------------
// Types matching bebop_v_ffi.h
// -----------------------------------------------------------------------------

/// Byte slice passed across FFI. Data is NOT NUL-terminated.
pub const VBytes = extern struct {
    ptr: ?[*]const u8,
    len: usize,

    pub fn empty() VBytes {
        return .{ .ptr = null, .len = 0 };
    }

    pub fn fromSlice(slice: []const u8) VBytes {
        return .{
            .ptr = if (slice.len > 0) slice.ptr else null,
            .len = slice.len,
        };
    }
};

/// Flat, FFI-friendly representation of SensorReading.
pub const VSensorReading = extern struct {
    timestamp: u64,
    sensor_id: VBytes,
    sensor_type: u16,
    value: f64,
    unit: VBytes,
    location: VBytes,

    metadata_count: usize,
    metadata_keys: ?[*]VBytes,
    metadata_values: ?[*]VBytes,

    error_code: i32,
    error_message: ?[*:0]const u8,

    pub fn empty() VSensorReading {
        return .{
            .timestamp = 0,
            .sensor_id = VBytes.empty(),
            .sensor_type = 0,
            .value = 0.0,
            .unit = VBytes.empty(),
            .location = VBytes.empty(),
            .metadata_count = 0,
            .metadata_keys = null,
            .metadata_values = null,
            .error_code = 0,
            .error_message = null,
        };
    }
};

// Error codes
pub const ERR_OK: i32 = 0;
pub const ERR_NULL_CTX: i32 = -1;
pub const ERR_NULL_DATA: i32 = -2;
pub const ERR_INVALID_LENGTH: i32 = -3;
pub const ERR_DECODE_FAILED: i32 = -4;
pub const ERR_NOT_IMPLEMENTED: i32 = -99;

// -----------------------------------------------------------------------------
// Context (arena-based allocator for zero-copy decode)
// -----------------------------------------------------------------------------

pub const BebopCtx = struct {
    arena: std.heap.ArenaAllocator,
    error_buf: [256]u8,
    error_msg: ?[*:0]const u8,

    pub fn init() *BebopCtx {
        const backing = std.heap.page_allocator;
        const ctx = backing.create(BebopCtx) catch return @ptrFromInt(0);
        ctx.* = .{
            .arena = std.heap.ArenaAllocator.init(backing),
            .error_buf = undefined,
            .error_msg = null,
        };
        return ctx;
    }

    pub fn deinit(self: *BebopCtx) void {
        self.arena.deinit();
        std.heap.page_allocator.destroy(self);
    }

    pub fn reset(self: *BebopCtx) void {
        _ = self.arena.reset(.retain_capacity);
        self.error_msg = null;
    }

    pub fn allocator(self: *BebopCtx) Allocator {
        return self.arena.allocator();
    }

    pub fn setError(self: *BebopCtx, msg: []const u8) void {
        const len = @min(msg.len, self.error_buf.len - 1);
        @memcpy(self.error_buf[0..len], msg[0..len]);
        self.error_buf[len] = 0;
        self.error_msg = @ptrCast(&self.error_buf);
    }
};

// -----------------------------------------------------------------------------
// Exported C ABI functions
// -----------------------------------------------------------------------------

/// Create a new context. Returns null on allocation failure.
export fn bebop_ctx_new() callconv(.C) ?*BebopCtx {
    const ctx = BebopCtx.init();
    if (@intFromPtr(ctx) == 0) return null;
    return ctx;
}

/// Free a context and all its allocations.
export fn bebop_ctx_free(ctx: ?*BebopCtx) callconv(.C) void {
    if (ctx) |c| {
        c.deinit();
    }
}

/// Reset context arena for reuse (high-throughput pattern).
export fn bebop_ctx_reset(ctx: ?*BebopCtx) callconv(.C) void {
    if (ctx) |c| {
        c.reset();
    }
}

/// Decode a SensorReading from Bebop wire format.
/// Returns 0 on success, negative error code on failure.
export fn bebop_decode_sensor_reading(
    ctx: ?*BebopCtx,
    data: ?[*]const u8,
    len: usize,
    out: ?*VSensorReading,
) callconv(.C) i32 {
    const c = ctx orelse return ERR_NULL_CTX;
    const output = out orelse return ERR_NULL_DATA;
    const bytes = data orelse return ERR_NULL_DATA;

    if (len == 0) return ERR_INVALID_LENGTH;

    // TODO: Implement actual Bebop decoding
    // For now, return a stub response for MVP
    _ = bytes;
    _ = c;

    output.* = VSensorReading.empty();
    output.error_code = ERR_NOT_IMPLEMENTED;
    c.setError("decode not yet implemented");
    output.error_message = c.error_msg;

    return ERR_NOT_IMPLEMENTED;
}

/// Free per-reading allocations. Safe to call multiple times.
export fn bebop_free_sensor_reading(ctx: ?*BebopCtx, reading: ?*VSensorReading) callconv(.C) void {
    // With arena allocation, individual frees are no-ops.
    // Memory is reclaimed on ctx reset/free.
    _ = ctx;
    if (reading) |r| {
        r.* = VSensorReading.empty();
    }
}

/// Encode a batch of readings. Returns bytes written, 0 on failure.
export fn bebop_encode_batch_readings(
    ctx: ?*BebopCtx,
    readings: ?[*]const VSensorReading,
    count: usize,
    out_buf: ?[*]u8,
    out_len: usize,
) callconv(.C) usize {
    _ = ctx;
    _ = readings;
    _ = count;
    _ = out_buf;
    _ = out_len;

    // TODO: Implement actual Bebop encoding
    return 0; // Not implemented
}

// -----------------------------------------------------------------------------
// Tests
// -----------------------------------------------------------------------------

test "context lifecycle" {
    const ctx = bebop_ctx_new();
    try std.testing.expect(ctx != null);

    bebop_ctx_reset(ctx);
    bebop_ctx_free(ctx);
}

test "decode returns not implemented" {
    const ctx = bebop_ctx_new();
    defer bebop_ctx_free(ctx);

    var reading = VSensorReading.empty();
    const data = [_]u8{ 0x00, 0x01, 0x02 };
    const result = bebop_decode_sensor_reading(ctx, &data, data.len, &reading);

    try std.testing.expectEqual(ERR_NOT_IMPLEMENTED, result);
}

test "VBytes from slice" {
    const slice = "hello";
    const vb = VBytes.fromSlice(slice);
    try std.testing.expectEqual(@as(usize, 5), vb.len);
}

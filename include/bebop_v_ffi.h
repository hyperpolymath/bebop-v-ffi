// SPDX-License-Identifier: AGPL-3.0-or-later
// SPDX-FileCopyrightText: 2025 Hyperpolymath Contributors
//
// bebop_v_ffi.h - Stable C ABI contract for Bebop-V bindings
//
// This header defines the FFI boundary. Implementations (Zig, Rust, etc.)
// must conform to these signatures. V bindings call these functions.
//
// ABI STABILITY GUARANTEE:
// - Version 1.x.x: Backwards compatible (no breaking changes)
// - Structs: Fields may be added at end only, never removed/reordered
// - Functions: New functions may be added, existing signatures frozen
// - Error codes: New codes may be added, existing values frozen

#ifndef BEBOP_V_FFI_H
#define BEBOP_V_FFI_H

#include <stddef.h>
#include <stdint.h>

/* ABI Version - LOCKED */
#define BEBOP_V_FFI_VERSION_MAJOR 1
#define BEBOP_V_FFI_VERSION_MINOR 0
#define BEBOP_V_FFI_VERSION_PATCH 0
#define BEBOP_V_FFI_VERSION_STRING "1.0.0"

/* Combine version for runtime checks: (major << 16) | (minor << 8) | patch */
#define BEBOP_V_FFI_VERSION \
    ((BEBOP_V_FFI_VERSION_MAJOR << 16) | \
     (BEBOP_V_FFI_VERSION_MINOR << 8) | \
     BEBOP_V_FFI_VERSION_PATCH)

#ifdef __cplusplus
extern "C" {
#endif

/* Error codes - LOCKED (values frozen, new codes may be added) */
#define BEBOP_OK                    0
#define BEBOP_ERR_NULL_CTX         -1
#define BEBOP_ERR_NULL_DATA        -2
#define BEBOP_ERR_INVALID_LENGTH   -3
#define BEBOP_ERR_DECODE_FAILED    -4
#define BEBOP_ERR_ENCODE_FAILED    -5
#define BEBOP_ERR_BUFFER_TOO_SMALL -6
#define BEBOP_ERR_NOT_IMPLEMENTED  -99

/* Opaque context for allocations and state. Prefer one context per connection/thread. */
typedef struct BebopCtx BebopCtx;

/* Byte slice passed across FFI. Data is not NUL-terminated. */
typedef struct VBytes {
    const uint8_t* ptr;
    size_t len;
} VBytes;

/* Flat, FFI-friendly representation of SensorReading (schema-defined). */
typedef struct VSensorReading {
    uint64_t timestamp;
    VBytes sensor_id;
    uint16_t sensor_type;
    double value;
    VBytes unit;
    VBytes location;

    size_t metadata_count;
    VBytes* metadata_keys;
    VBytes* metadata_values;

    int32_t error_code;
    const char* error_message; /* NUL-terminated; owned by implementation (ctx). */
} VSensorReading;

/* SensorType enum values (matches sensors.bop) */
#define SENSOR_TYPE_TEMPERATURE  1
#define SENSOR_TYPE_HUMIDITY     2
#define SENSOR_TYPE_PRESSURE     3
#define SENSOR_TYPE_VIBRATION    4

/* Version query - returns BEBOP_V_FFI_VERSION */
uint32_t bebop_version(void);

/* Context lifecycle */
BebopCtx* bebop_ctx_new(void);
void bebop_ctx_free(BebopCtx* ctx);
void bebop_ctx_reset(BebopCtx* ctx);

/* Decode/encode */
int32_t bebop_decode_sensor_reading(
    BebopCtx* ctx,
    const uint8_t* data,
    size_t len,
    VSensorReading* out
);

/* Frees any per-reading allocations (if needed). Safe to call multiple times. */
void bebop_free_sensor_reading(BebopCtx* ctx, VSensorReading* reading);

/* Encode a batch of readings into out_buf. Returns bytes written (0 on failure). */
size_t bebop_encode_batch_readings(
    BebopCtx* ctx,
    const VSensorReading* readings,
    size_t count,
    uint8_t* out_buf,
    size_t out_len
);

#ifdef __cplusplus
}
#endif

#endif /* BEBOP_V_FFI_H */

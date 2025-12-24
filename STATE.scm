;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Hyperpolymath Contributors
;;
;; STATE.scm - Current project state and progress tracking

(state
 (metadata
  (version 1)
  (schema-version "0.0.1")
  (created "2025-12-24")
  (updated "2025-12-24")
  (project "bebop-v-ffi")
  (repo "github.com/hyperpolymath/bebop-v-ffi"))

 (project-context
  (name "Bebop-V-FFI")
  (tagline "FFI bindings for Bebop binary serialization in V")
  (tech-stack V Zig C Bebop))

 (current-position
  (phase "mvp-ready")
  (overall-completion 25)
  (version "0.0.1")
  (components
   ((name "ABI header")
    (status complete)
    (file "include/bebop_v_ffi.h"))
   ((name "V bindings")
    (status complete)
    (file "v/bebop_bridge.v"))
   ((name "V examples")
    (status complete)
    (files "v/iiot_server.v" "v/iiot_client.v"))
   ((name "Zig build system")
    (status complete)
    (file "implementations/zig/build.zig"))
   ((name "Zig implementation")
    (status stub)
    (file "implementations/zig/src/bridge.zig")
    (note "Context lifecycle works, decode/encode return NOT_IMPLEMENTED"))
   ((name "Rust implementation")
    (status help-wanted)
    (file "implementations/rust/"))
   ((name "Schema")
    (status complete)
    (file "schemas/sensors.bop"))
   ((name "Documentation")
    (status complete)
    (files "docs/*.adoc" "README.adoc" "ROADMAP.adoc"))
   ((name "White paper")
    (status complete)
    (file "docs/WHITEPAPER.adoc"))
   ((name "Golden vectors")
    (status placeholder)
    (file "test-vectors/sensor_reading_001.json")))
  (working-features
   "Schema definition"
   "ABI contract design"
   "V binding structure"
   "Zig build and test"
   "Context lifecycle (new/reset/free)"
   "Stub decode/encode"))

 (route-to-mvp
  ((milestone "M0: Scaffold — COMPLETE")
   (status complete)
   (items
    "ABI header"
    "V bindings"
    "Zig build system"
    "Documentation"
    "White paper"))
  ((milestone "M1: Working Decode")
   (status next)
   (items
    "Implement bebop_decode_sensor_reading in Zig"
    "Generate real wire bytes for golden vectors"
    "Pass decode test"))
  ((milestone "M2: Working Encode")
   (status pending)
   (items
    "Implement bebop_encode_batch_readings"
    "Round-trip test"))
  ((milestone "M3: V Integration")
   (status pending)
   (items
    "End-to-end test with V examples"
    "Link V to Zig .so")))

 (blockers-and-issues
  (critical)
  (high
   "Decode/encode not yet implemented (stubs only)")
  (medium
   "Golden vectors need real wire bytes from bebopc"
   "No CI pipeline yet")
  (low
   "Rust implementation help wanted"))

 (critical-next-actions
  (immediate
   "Implement actual Bebop decode in Zig")
  (this-week
   "Generate wire bytes with bebopc"
   "Set up CI")
  (this-month
   "Complete encode"
   "V integration test")))

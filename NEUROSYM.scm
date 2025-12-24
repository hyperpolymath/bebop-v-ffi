;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Hyperpolymath Contributors
;;
;; NEUROSYM.scm - Neural-symbolic integration patterns for this repository

(neurosym
 (version 1)
 (project "bebop-v-ffi")

 (reasoning-domains
  ((domain "abi-design")
   (type symbolic)
   (constraints
    "Struct layouts must match C ABI"
    "Alignment rules are deterministic"
    "Ownership semantics are explicit")
   (tools "static-analysis" "formal-verification"))

  ((domain "wire-format")
   (type symbolic)
   (constraints
    "Bebop spec is authoritative"
    "Little-endian encoding"
    "Length-prefixed framing")
   (tools "golden-vectors" "round-trip-tests"))

  ((domain "implementation-patterns")
   (type hybrid)
   (neural-assists
    "Suggest idiomatic Zig/Rust patterns"
    "Identify common FFI pitfalls"
    "Propose test coverage gaps")
   (symbolic-constraints
    "Must satisfy ABI contract"
    "Must pass golden vectors")))

 (verification-strategy
  (primary "test-vectors")
  (secondary "type-system-guarantees")
  (aspirational "formal-abi-proofs"))

 (knowledge-sources
  ((source "bebop-spec")
   (type authoritative)
   (url "https://bebop.sh/reference/"))
  ((source "v-ffi-docs")
   (type authoritative)
   (url "https://github.com/vlang/v/blob/master/doc/docs.md#calling-c-from-v"))
  ((source "zig-c-interop")
   (type authoritative)
   (url "https://ziglang.org/documentation/master/#C-Type-Primitives")))

 (invariants
  "VBytes uses ptr+len, never NUL-terminated"
  "Context owns all allocations"
  "Decode outputs valid until ctx reset/free"
  "Encode returns bytes written or 0 on failure"))

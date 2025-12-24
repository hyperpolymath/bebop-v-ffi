;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Hyperpolymath Contributors
;;
;; ECOSYSTEM.scm - Project relationships and ecosystem positioning
;; Media-Type: application/vnd.ecosystem+scm

(ecosystem
 (version 1)
 (name "bebop-v-ffi")
 (type "library")
 (purpose "FFI bindings between Bebop binary serialization and V language")

 (position-in-ecosystem
  (layer "infrastructure")
  (domain "serialization")
  (target "iiot-edge"))

 (related-projects
  ((name "kaldor-iiot")
   (relationship parent)
   (description "Parent IIoT platform - primary consumer"))

  ((name "bunsenite")
   (relationship sibling-standard)
   (description "Similar FFI architecture for Nickel parser"))

  ((name "bebop")
   (relationship upstream-dependency)
   (url "https://bebop.sh")
   (description "Binary serialization format - core technology"))

  ((name "vlang")
   (relationship upstream-dependency)
   (url "https://vlang.io")
   (description "Target language for bindings")))

 (what-this-is
  "A stable C ABI contract exposing Bebop to V"
  "Multiple backend implementations (Zig, Rust) behind one interface"
  "Zero-copy decode/encode for IIoT edge devices")

 (what-this-is-not
  "A reimplementation of Bebop wire format"
  "A general-purpose serialization library"
  "A networking library"))

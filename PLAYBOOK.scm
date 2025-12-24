;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Hyperpolymath Contributors
;;
;; PLAYBOOK.scm - Operational runbooks and procedures

(playbook
 (version 1)
 (project "bebop-v-ffi")

 (runbooks
  ((id "add-new-message-type")
   (description "Add a new Bebop message type to the FFI")
   (steps
    "1. Add message to schemas/*.bop"
    "2. Run scripts/gen_c_from_schema.sh"
    "3. Add corresponding struct to include/bebop_v_ffi.h"
    "4. Add decode/encode functions to header"
    "5. Update v/bebop_bridge.v with V bindings"
    "6. Implement in Zig (implementations/zig/)"
    "7. Add golden test vectors"
    "8. Update docs if needed"))

  ((id "add-implementation")
   (description "Add a new language implementation (e.g., Rust)")
   (steps
    "1. Create implementations/<lang>/ directory"
    "2. Implement all functions from bebop_v_ffi.h"
    "3. Use VBytes for all byte slices"
    "4. Implement context-based allocation"
    "5. Pass all golden vector tests"
    "6. Document build process"
    "7. Add to CI matrix"))

  ((id "release-checklist")
   (description "Steps before tagging a release")
   (steps
    "1. All golden vector tests pass"
    "2. ABI header unchanged or version bumped"
    "3. CHANGELOG updated"
    "4. STATE.scm updated"
    "5. Docs reflect current state"
    "6. CI green on all platforms"
    "7. Tag with semantic version"))

  ((id "debug-decode-failure")
   (description "Troubleshoot decode failures")
   (steps
    "1. Check wire bytes against golden vectors"
    "2. Verify framing (4-byte length prefix)"
    "3. Check endianness (little-endian)"
    "4. Validate schema version match"
    "5. Check context not already freed"
    "6. Run with debug logging enabled"))

  ((id "abi-breaking-change")
   (description "Process for ABI-breaking changes")
   (steps
    "1. Document reason in ADR"
    "2. Bump major version"
    "3. Update all implementations"
    "4. Update V bindings"
    "5. Regenerate golden vectors"
    "6. Notify downstream consumers"
    "7. Update migration guide")))

 (emergency-procedures
  ((id "revert-bad-release")
   (steps
    "1. git revert to last known good"
    "2. Tag new patch release"
    "3. Notify consumers"
    "4. Post-mortem in docs/incidents/"))))

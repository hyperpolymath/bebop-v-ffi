;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Hyperpolymath Contributors
;;
;; AGENTIC.scm - AI/Agent interaction policies for this repository

(agentic
 (version 1)
 (project "bebop-v-ffi")

 (agent-role
  (primary "design-assistant")
  (description "AI assists with design, docs, and examples but does not author ABI changes"))

 (boundaries
  (can-do
   "Propose API shapes and struct layouts"
   "Draft documentation and examples"
   "Explain existing code and design rationale"
   "Suggest test cases and edge conditions"
   "Review code for common FFI pitfalls"
   "Generate V usage examples")

  (cannot-do
   "Modify include/bebop_v_ffi.h without human review"
   "Change serialization logic"
   "Alter build system (build.zig, Cargo.toml)"
   "Push commits directly"
   "Refactor across language boundaries"
   "Migrate between implementations"))

 (review-gates
  ((artifact "ABI header changes")
   (requires human-sign-off)
   (reason "ABI stability is core deliverable"))
  ((artifact "Serialization logic")
   (requires human-sign-off)
   (reason "Wire format correctness critical"))
  ((artifact "Build scripts")
   (requires human-sign-off)
   (reason "Toolchain changes affect all consumers")))

 (interaction-style
  (verbosity concise)
  (code-generation cautious)
  (proactive-suggestions allowed)
  (explain-before-act required))

 (trust-escalation
  (default-level "propose-only")
  (escalation-path
   "propose-only -> draft-with-review -> implement-with-approval")))

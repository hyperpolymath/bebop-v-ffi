;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Hyperpolymath Contributors
;;
;; META.scm - Governance and design principles for bebop-v-ffi
;; Media-Type: application/meta+scheme

(meta
 (version 1)

 (principles
  ((id design-not-authority)
   (statement
    "Let the LLM help design rules, but never let it be the rule.")))

 (allowed
  propose_architecture
  draft_docs
  suggest_api_shapes
  generate_examples
  explain_existing_code)

 (forbidden
  direct_commits
  automated_refactors
  language_migration
  dependency_rewrites
  build_system_changes
  ci_changes
  formatting_sweeps)

 (requires_human_review
  ffi_boundaries
  abi_headers
  build_scripts
  serialization_logic
  schema_changes
  security_sensitive_code)

 (enforcement
  (ci
   check_language_drift
   check_build_tooling
   check_schema_versions)
  (human
   mandatory_review
   commit_message_attestation)))

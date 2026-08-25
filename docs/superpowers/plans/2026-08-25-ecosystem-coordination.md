# Ecosystem Coordination Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` or `superpowers:executing-plans` task-by-task. Steps use checkbox syntax for tracking.

**Goal:** Establish a documented, testable boundary among template-bash-cli, devkit, and homebrew-tap without changing an application's runtime contract.

**Architecture:** template-bash-cli supplies a Bash-specific project/artifact contract; devkit later dispatches that contract as a template-neutral lifecycle tool; homebrew-tap transports already verified public artifacts. The first delivery is documentation and public-source recovery, not a framework rewrite.

**Tech Stack:** Bash 5.1+, argc, GitHub, GitHub Releases/tags, Homebrew Formulae, existing Swift template.

**Spec:** [North Star](../../north-star.md), [ecosystem map](../../ecosystem.md), and [decision 0002](../../decisions/0002-ecosystem-roles-and-public-distribution.md).

## Global Constraints

- Do not make framework/build tooling a runtime dependency of a compiled Bash application.
- Preserve current repository history and current template/Swift behavior; do not split repositories in this plan.
- GitHub is the public distribution authority. Public installs must not require Gitea.
- Publish an immutable public artifact before changing a formula URL or checksum.
- `keyagent` is a separate public-source decision; never silently delete or publish it.
- A tag, release, formula push, npm publish, or tap update is an explicit external-authorization gate.
- A package manager transports `dist/bin/<application>`; it does not gain a second compilation path.

---

### Task 1: Land and maintain the ecosystem contract

**Files:**

- Create: `AGENTS.md`, `docs/ecosystem.md`, `docs/decisions/0002-ecosystem-roles-and-public-distribution.md`
- Modify: `README.md`, `docs/north-star.md`, `docs/architecture.md`, `docs/decisions/README.md`
- Test: documentation link and whitespace checks

**Consumes:** Existing North Star and decision-log conventions.

**Produces:** A tracked source of truth for repository roles, public supply-chain order, command ownership, and external handoff links.

- [ ] Verify that all three repositories are clean before documentation edits:

  ```bash
  git -C /Users/kwaight/src/template-bash-cli status --short --branch
  git -C /Users/kwaight/src/devkit status --short --branch
  git -C /Users/kwaight/src/homebrew-tap status --short --branch
  ```

  Expected: each repository reports its tracking branch with no changed paths.

- [ ] Add the ecosystem map and decision record using the exact role split in decision 0002.
- [ ] Link the documents from the README and agent guide; do not add a framework dependency or change build code.
- [ ] Verify documentation integrity:

  ```bash
  git diff --check
  rg -n '\[.*\]\([^)]*\)' README.md docs AGENTS.md
  ```

  Expected: no whitespace errors and every local link names an existing path.

- [ ] Commit the documentation-only change before beginning cross-repository implementation:

  ```bash
  git add AGENTS.md README.md docs
  git commit -m "docs: define ecosystem coordination boundary"
  ```

### Task 2: Make devkit's public artifact independently verifiable

**Repository:** `/Users/kwaight/src/devkit`

**Files:**

- Create: `docs/superpowers/plans/2026-08-25-public-distribution-and-bash-cli-coordination.md`
- Modify later: `README.md`, `bin/new-tool`, `bin/release-tool`, new focused tests/workflows only after the lifecycle contract is documented
- External gate: remote `v0.1.0` tag/release and GitHub public artifact

**Consumes:** The public-source rule and devkit's existing local `v0.1.0` tag.

**Produces:** A public immutable devkit artifact with an anonymously retrievable checksum, plus an explicit Swift/template/provider responsibility map.

- [ ] Inspect whether GitHub advertises the existing tag before mutating anything:

  ```bash
  git -C /Users/kwaight/src/devkit show-ref --verify refs/tags/v0.1.0
  git ls-remote --tags git@github.com:kieferwaight/devkit.git v0.1.0
  ```

  Expected now: the local tag exists and the remote tag is absent.

- [ ] Obtain explicit authorization before pushing the tag or creating a release. Do not retag or replace `v0.1.0`.
- [ ] After authorization, push the existing immutable tag, then verify anonymous availability and calculate the exact SHA-256 of the public archive or release asset.
- [ ] Document the lifecycle seam: generic orchestration consumes template-declared name, version, build/test hooks, canonical artifact, and release metadata; Swift source layout/version parsing stays in the Swift adapter.
- [ ] Preserve `new-tool` and `release-tool` behavior while replacing implicit Gitea defaults with an explicit provider adapter in a later, separately tested task.

### Task 3: Recover the devkit Homebrew path only after artifact verification

**Repository:** `/Users/kwaight/src/homebrew-tap`

**Files:**

- Create: `docs/superpowers/plans/2026-08-25-public-tap-recovery.md`
- Modify later: `Formula/devkit.rb`, `README.md`, optional CI workflow
- Do not modify: `Formula/keyagent.rb` without an explicit source/disposition decision

**Consumes:** A publicly reachable immutable devkit artifact and its verified SHA-256.

**Produces:** A public-only `devkit` Formula and real clean-consumer installation evidence.

- [ ] Before changing `Formula/devkit.rb`, retrieve the exact final archive anonymously and compare its SHA-256 to the intended formula value.
- [ ] Update the formula homepage, URL, version, and checksum in one change. Do not use a branch archive, current `main`, a private Gitea URL, or a guessed checksum.
- [ ] Add a minimal README that advertises only verified formulas:

  ```bash
  brew tap kieferwaight/tap
  brew install devkit
  ```

- [ ] Validate the actual consumer path in a clean Homebrew context:

  ```bash
  brew tap kieferwaight/tap
  brew install devkit
  brew test devkit
  ```

  Expected: download is anonymous/public, checksum matches, installation succeeds, and the formula's `test do` passes.

- [ ] Record a separate decision for keyagent: public artifact plus successful Formula test, or explicit formula removal. Do not treat an inaccessible formula as a normal active package.

### Task 4: Prove the future template-neutral lifecycle seam

**Repositories:** `/Users/kwaight/src/template-bash-cli`, `/Users/kwaight/src/devkit`

**Files:**

- Modify later: template manifest/contract documentation and devkit template resolver only after Task 2 and Task 3 pass
- Test later: one Swift project and one Bash project exercising the same lifecycle contract

**Consumes:** A stable public devkit artifact and a repaired public devkit formula.

**Produces:** Evidence that devkit can dispatch a template contract rather than hard-code a language or package manager.

- [ ] Define a minimal adapter input contract: project name, version, build command, test command, canonical artifact path, and declared runtime dependencies.
- [ ] Keep `bash-cli` focused on Bash-specific composition/conformance. Defer public `bash-cli init`, `release`, and `publish` commands.
- [ ] Make `devkit init <template> <project>` the primary cross-template creation interface. If `devkit build`/`test`/`publish` are added, implement them as dispatchers to the template contract.
- [ ] Verify both sample projects build their own canonical artifact and that a distributor transports it without recompilation.

### Task 5: Review reduction and compatibility evidence

**Files:**

- Modify: relevant North Star decision records only when evidence changes a contract
- Test: repository-specific tests plus cross-repository clean-consumer installation

**Consumes:** Results from Tasks 1–4.

**Produces:** An updated decision record identifying framework machinery that can leave generated projects.

- [ ] Compare the initial generated Bash project with the evolved minimal project.
- [ ] Remove only framework-owned files whose behavior is now supplied by a tested toolchain contract.
- [ ] Never rewrite application-owned commands, business logic, tests, README content, or explicit overrides during migration.
- [ ] Record the evidence, compatibility impact, and rollback path in a new decision-log entry before declaring a contract stable.

## Execution Handoff

Use three agents in dependency order:

1. **Template coordinator** maintains the cross-repository contract and reviews compatibility evidence.
2. **Devkit owner** establishes the public artifact and documents/extracts lifecycle seams; it blocks the tap agent until artifact verification succeeds.
3. **Tap owner** updates only verified Formulae and proves consumer installation; keyagent is a separate gated task.

Do not parallelize artifact publication and formula mutation. Documentation work can proceed in parallel; public distribution changes cannot.

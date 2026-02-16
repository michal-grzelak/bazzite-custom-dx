# Design: Refactored Developer Experience

## Context

### Current State

The repository currently has an outdated DX configuration:

- Uses deprecated `rpm-ostree` module instead of modern `dnf` module
- Monolithic structure in `recipes/dx/` with flat file organization
- Legacy dx-groups script (version 1) that doesn't support Incus
- Direct repo file placement in `files/system/etc/yum.repos.d/`
- QEMU package list is partial and untested against Aurora DX

### Target State

Aurora DX provides a validated, production-ready developer workstation setup with:

- Modern `dnf` module with isolated COPR installation pattern
- Comprehensive package lists tested across Fedora versions
- Versioned group management with incus-admin support
- Full container ecosystem (Docker, Podman, Incus, LXC)
- AI/ML tooling with LM Studio

### Base Image Context

This configuration builds on top of Bazzite (gaming-focused Fedora Atomic), which already includes:

- Basic virtualization (qemu, libvirt)
- Basic containers (podman, distrobox)
- ROCm for AMD GPU compute
- Steam, Lutris, gaming tools

## Goals / Non-Goals

**Goals:**

- Migrate from `rpm-ostree` to `dnf` module (BlueBuild best practice)
- Organize modules into logical, nested boundaries (dev/, virtualization/, security/, ai/, dotfiles/, system/)
- Achieve parity with Aurora DX developer tools and virtualization stack
- Add AI tooling (LM Studio) for local LLM development
- Implement proper group management with incus-admin support
- Isolate COPR installations for security (Aurora pattern)
- Provide chezmoi skeleton for future dotfiles repository
- Document temporary overrides that may change with Fedora updates

**Non-Goals:**

- Replacing Bazzite's gaming optimizations (this extends, not replaces)
- Adding IDE options beyond VSCode (keep it minimal)
- Supporting NVIDIA-specific AI tooling (ROCm is already in Bazzite)
- Creating the actual chezmoi dotfiles repository (only skeleton)
- Backward compatibility with current DX module structure (breaking change)

## Decisions

### Decision: Module Directory Structure

**Choice:** Nest module configurations under `recipes/` category subdirectories (`recipes/dev/`, `recipes/virtualization/`, etc.)

**Rationale:**

- Root `modules/` folder is reserved for custom BlueBuild module scripts (Nushell)
- Recipe configurations belong in `recipes/` directory per BlueBuild conventions
- Logical separation of concerns improves maintainability
- Follows Aurora DX's implicit organization patterns
- Allows granular inclusion/exclusion in different image variants

**Important Note:** The `from-file:` references in recipe-bazzite.yml are relative to the `recipes/` directory.

**Alternative Considered:** Keep flat structure (rejected: harder to navigate at scale)

### Decision: Use Modern `dnf` Module

**Choice:** Replace all `rpm-ostree` modules with `dnf` module

**Rationale:**

- `dnf` is the recommended module in BlueBuild documentation
- Better dependency resolution with dnf5
- Supports modern features like repos.files for URL-based repos
- Aurora DX has validated this approach

**Migration:** All existing rpm-ostree configurations must be converted to dnf format

### Decision: Use dnf Module's Native COPR Support

**Choice:** Use the dnf module's native COPR repository support

**Rationale:**

- BlueBuild dnf module has built-in COPR support via `repos.copr`
- More declarative and maintainable than script snippets
- Properly integrated with dnf5's repository management
- Follows BlueBuild best practices

**Implementation:**

```yaml
type: dnf
repos:
  copr:
    - name: owner/repo
install:
  packages:
    - package-name
```

**Note:** Aurora DX uses isolated enable/disable pattern via scripts for additional security. For maximum security parity, the `dnf` module with `repos.copr` is the BlueBuild-native approach.

### Decision: LM Studio AppImage Installation

**Choice:** Install LM Studio as AppImage rather than waiting for RPM

**Rationale:**

- LM Studio only provides AppImage for Linux (no RPM available)
- AppImage is self-contained and doesn't conflict with system libraries
- Chrome sandbox needs special permissions for GPU acceleration

**Installation Steps:**

1. Download AppImage from lmstudio.ai to `/opt/lmstudio/`
2. Make executable with chmod +x
3. Extract with --appimage-extract for chrome-sandbox permissions
4. Set chrome-sandbox to root:root with 4755 permissions
5. Create desktop entry for application menu
6. Bootstrap lms CLI with `~/.lmstudio/bin/lms bootstrap`

**Temporary Override:** Chrome sandbox setuid may change if LM Studio updates their packaging

### Decision: Group Setup Script Version 2

**Choice:** Adopt Aurora's version 2 group setup with incus-admin support

**Changes from Version 1:**

- Version bumped to 2 (stored in /etc/ublue/dx-groups)
- Adds incus-admin group support
- Uses append_group function for idempotent group creation
- Removes qemu group (not needed with modern libvirt)

**File Location:** `/usr/libexec/dx-groups` with systemd service

### Decision: IP Forwarding and iptable_nat Workarounds

**Choice:** Apply Aurora's network workarounds before Docker installation

**Rationale:**

- IP forwarding prevents LXC networking conflicts with Docker
- iptable_nat module enables docker-in-docker scenarios
- These are temporary workarounds documented as such

**Temporary Override:** These may become unnecessary with future Fedora kernel updates

### Decision: Chezmoi Skeleton Only

**Choice:** Provide configuration template, not actual dotfiles

**Rationale:**

- User wants to create their own repository later
- Skeleton shows recommended configuration structure
- Avoids imposing specific dotfiles choices

**Template Location:** `/etc/skel/.config/chezmoi/chezmoi.toml`

### Decision: Flatpak DevPod and Gear Lever System Installation

**Choice:** Install DevPod and Gear Lever as system flatpaks (not user)

**Rationale:**

- System flatpaks are available to all users
- Prevents accidental removal
- DevPod: Follows Aurora DX pattern for essential dev tools
- Gear Lever: Provides GUI AppImage management for users, complements manual LM Studio installation

**Note on Gear Lever vs LM Studio:** Gear Lever is installed as a general AppImage management tool for user convenience. LM Studio is still installed manually via script module because:

- It requires chrome-sandbox permission fixes that Gear Lever doesn't handle
- System-wide installation in /opt/lmstudio/ makes it available to all users
- Pre-configured desktop entry and lms CLI bootstrapping

### Decision: GPU-Specific Package Architecture

**Context:** This repository may build multiple image variants (AMD/main, NVIDIA). Some packages are GPU-specific.

**GPU-Specific Packages Identified:**
| Package | AMD/Main | NVIDIA | Notes |
|---------|----------|--------|-------|
| clblast | Required | Not needed | OpenCL BLAS for AMD/Intel GPU acceleration in LM Studio |
| rocm-\* | Already in Bazzite base | Excluded | Bazzite base handles this |
| cuda | Not needed | May be needed | For NVIDIA Docker containers (out of scope) |

**Architecture Decision:**

- **Base modules** (GPU-agnostic): `ai/lmstudio.yml` - core LM Studio installation
- **GPU-specific modules**: `ai/lmstudio-amd.yml`, `ai/lmstudio-nvidia.yml` (if needed)
- **Recipe variants**:
  - `recipe-bazzite.yml` (AMD/main) includes base + amd modules
  - `recipe-bazzite-nvidia.yml` (NVIDIA) includes base only (or + nvidia modules)

**Implementation:**

```yaml
# ai/lmstudio.yml - GPU agnostic base
- type: script  # Downloads LM Studio, sets up chrome-sandbox

# ai/lmstudio-amd.yml - AMD/Intel specific
- type: dnf
  install:
    packages:
      - clblast

# recipe-bazzite.yml (AMD/main)
modules:
  - from-file: ai/lmstudio.yml      # Base
  - from-file: ai/lmstudio-amd.yml  # AMD deps

# recipe-bazzite-nvidia.yml (NVIDIA)
modules:
  - from-file: ai/lmstudio.yml      # Base only
  # - from-file: ai/lmstudio-nvidia.yml  # If NVIDIA-specific deps needed
```

### Decision: File Structure Changes

**Current Structure (to be removed):**

```
recipes/
  recipe-bazzite.yml  # main recipe
  dx.yml              # monolithic
  dx/
    common.yml        # flat
    cockpit.yml
    docker.yml
    qemu.yml
    brew.yml
    system-services.yml
files/
  system/
    etc/yum.repos.d/  # direct repo files
      1password.repo
      vscode.repo
      docker-ce.repo
```

**New Structure:**

```
recipes/
  recipe-bazzite.yml              # AMD/main image
  dx.yml                          # orchestrator (shared)
  dx-amd.yml                      # AMD-specific DX packages
  common.yml                      # 1password moves to security module
  dev/
    brew.yml                      # + mise
    vscode.yml                    # + devcontainer CLI
    docker.yml
    podman.yml                    # new - split from docker
  virtualization/
    qemu.yml                      # full Aurora package set
    libvirt.yml                   # + kcli, podman-bootc, virt-v2v via copr
    incus.yml                     # new
  security/
    1password.yml                 # moved from common.yml
  ai/
    lmstudio.yml                  # GPU-agnostic base
    lmstudio-amd.yml            # AMD/Intel specific (clblast)
  dotfiles/
    chezmoi.yml                   # new
  system/
    groups.yml                    # version 2 script
    cockpit.yml
    services.yml                  # unified service enables
    networking.yml                # ip forwarding, iptable_nat
  flatpaks/
    dev.yml                       # devpod, gearlever
files/
  scripts/
    setup-groups.sh               # version 2
  system/
    usr/lib/
      systemd/system/
        dx-groups.service
        libvirt-workaround.service
      tmpfiles.d/
        dx-groups.conf
    etc/skel/
      .config/
        chezmoi/
          chezmoi.toml
        Code/User/
          settings.json
```

**Important:** `from-file:` paths in recipe files are relative to the `recipes/` directory. For example:

- `from-file: dev/brew.yml` (not `recipes/dev/brew.yml`)
- `from-file: ai/lmstudio-amd.yml`

## Risks / Trade-offs

**[Risk] Breaking Change for Existing Users**
→ Mitigation: Clear migration documentation; old configs will be removed in single commit for easy revert

**[Risk] LM Studio AppImage Updates Break Chrome Sandbox**
→ Mitigation: Document as temporary override; monitor LM Studio releases for packaging changes

**[Risk] Incus Conflicts with Existing LXD (if user installed)**
→ Mitigation: Incus is LXD-compatible fork; document that users should not manually install LXD

**[Risk] COPR Packages May Become Unavailable**
→ Mitigation: Isolated COPR pattern limits exposure; Aurora DX maintains these COPRs actively

**[Risk] Docker CE vs Fedora Docker Package Conflicts**
→ Mitigation: Official Docker repo takes priority; documented in module comments

**[Risk] dnf Module Less Mature Than rpm-ostree**
→ Mitigation: Aurora DX has validated dnf module in production; fallback to rpm-ostree if issues arise

## Migration Plan

### Phase 1: Module Creation (This Change)

1. Create new module directory structure
2. Convert all rpm-ostree to dnf modules
3. Create version 2 group setup script
4. Add LM Studio AppImage installation

### Phase 2: Recipe Update

1. Update recipe-bazzite.yml to use new from-file: references
2. Remove old recipes/dx/ directory
3. Update files/ structure

### Phase 3: Testing

1. Local build validation with bluebuild
2. Verify all services start correctly
3. Test group assignment for new users
4. Validate LM Studio GPU acceleration

### Phase 4: Rollback Strategy

If issues occur, revert to previous commit: `git revert <this-change-commit>`

## Temporary Overrides (Documented for Future Review)

The following configurations are temporary workarounds that may need updating:

1. **iptable_nat module loading** - Required for docker-in-docker; may become unnecessary with kernel updates
2. **IP forwarding sysctl** - Applied before Docker; Fedora may change default networking
3. **Chrome sandbox setuid** - LM Studio packaging requirement; may change if they use different sandbox
4. **clblast symlinks** - Workaround for LM Studio library paths; may be fixed upstream
5. **Isolated COPR pattern** - Individual enable/disable; BlueBuild may add native support
6. **Libvirt SELinux relabeling** - Workaround service; may become unnecessary with policy updates

## Open Questions

1. **LM Studio Version Pinning:** Should we pin LM Studio version or always download latest? (User decision needed)
2. **Mise Activation:** Should mise activate be added to shell profile automatically? (Default: no, user opts-in)
3. **DevPod Pre-configuration:** Should DevPod have default provider configs? (Default: no, user configures)
4. **NVIDIA Container Toolkit:** Needed for Docker GPU containers? (Out of scope for now)

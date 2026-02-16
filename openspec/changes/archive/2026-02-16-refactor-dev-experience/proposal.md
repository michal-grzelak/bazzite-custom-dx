# Proposal: Refactor Developer Experience Configuration

## Why

The current DX (Developer Experience) configuration in this repository is outdated and uses deprecated BlueBuild patterns (rpm-ostree module instead of modern dnf module). Aurora DX provides a comprehensive, well-structured developer setup that closes the gap between Bazzite's gaming focus and a productive developer workstation. This refactor modernizes the configuration, adopts Aurora DX best practices, and organizes modules into logical, isolated boundaries for maintainability.

## What Changes

### Major Refactors
- **BREAKING**: Migrate from deprecated `rpm-ostree` module to modern `dnf` module across all DX configurations
- **BREAKING**: Reorganize monolithic DX configuration into modular, nested structure (dev/, virtualization/, security/, ai/, dotfiles/)
- **BREAKING**: Replace current qemu packages with Aurora DX's validated set
- Remove outdated dx-groups script (version 1) and adopt Aurora's version 2 with incus-admin support

### New Capabilities
- **Incus**: Modern LXD alternative for system containers (Aurora DX standard)
- **LM Studio**: Local LLM GUI + CLI (lms) for AI development
- **DevContainer CLI**: VS Code remote containers support (`@devcontainers/cli` via npm)
- **Mise**: Polyglot runtime manager via Homebrew
- **Podman Machine**: VM-based containers for podman
- **DevPod**: Remote development environments (Flatpak)
- **Chezmoi**: Dotfiles management with skeleton configuration

### Enhanced Capabilities
- **Docker**: Full Docker CE stack with buildx, compose, and model plugin
- **Virtualization**: Complete virt-v2v, kcli, podman-bootc support
- **VSCode**: Pre-configured settings, devcontainer CLI integration
- **Security**: Isolated 1Password module with op CLI

### Removed/Deprecated
- Current `dx-groups` version 1 script (replaced by versioned Aurora approach)
- Individual repo files (1password.repo, vscode.repo, docker-ce.repo) - use dnf module repos instead
- Legacy libvirt-workaround (replaced by Aurora's ublue-os-libvirt-workarounds)

## Capabilities

### New Capabilities

| Capability | Description |
|------------|-------------|
| `dev-brew` | Homebrew setup with mise, analytics disabled, automatic updates |
| `dev-vscode` | VSCode from MS repo, devcontainer CLI, default settings |
| `dev-docker` | Docker CE full stack with iptables module workaround |
| `dev-podman` | Podman + podman-compose + podman-machine + podmansh |
| `virtualization-qemu` | QEMU system and user packages |
| `virtualization-libvirt` | libvirt + virt-manager + virt-viewer + virt-install + kcli |
| `virtualization-incus` | Incus + incus-agent + lxc containers |
| `security-1password` | 1Password GUI + op CLI via bling module |
| `ai-lmstudio` | LM Studio AppImage + lms CLI bootstrap (GPU-agnostic base) |
| `ai-lmstudio-amd` | AMD/Intel specific deps (clblast) for LM Studio |
| `dotfiles-chezmoi` | Chezmoi setup with placeholder config |
| `system-groups` | Versioned group setup service (docker, incus-admin, libvirt) |
| `system-cockpit` | Cockpit + machines, podman, ostree plugins |
| `flatpaks-dev` | DevPod, Gear Lever (AppImage manager), and other dev-focused flatpaks |

### Modified Capabilities
- None (this is a net-new DX setup on top of Bazzite base)

## Impact

### Build System
- Changes to: `recipes/`, `files/` directory structure (root `modules/` is for custom BlueBuild modules only)
- New module configuration structure: `recipes/dev/`, `recipes/virtualization/`, `recipes/security/`, `recipes/ai/`, `recipes/dotfiles/`, `recipes/system/`, `recipes/flatpaks/`
- Recipe updated to use `from-file:` for all modular components (paths relative to `recipes/`)

### System Configuration
- New systemd services: `dx-groups.service` (v2), `libvirt-workaround.service`
- New tmpfiles: `/usr/lib/tmpfiles.d/dx-groups.conf`
- IP forwarding sysctl applied pre-docker install
- iptable_nat module loading for docker-in-docker support

### User Experience
- Wheel users automatically added to: docker, libvirt, incus-admin groups
- VSCode: Pre-configured with custom title bar, nerd fonts, no auto-update
- Docker and Podman sockets enabled by default
- Cockpit available on port 9090 with VM management

### Security Considerations
- Uses BlueBuild dnf module's native COPR support (repos.copr) for COPR packages
- Homebrew analytics disabled
- Docker requires rootless setup or group membership
- Incus containers run unprivileged by default
- All dnf repositories are properly cleaned up after installation per dnf module behavior

### Temporary Overrides (Documented in Design)
The following configurations are temporary workarounds that may change:
- iptable_nat kernel module loading for docker-in-docker
- Libvirt SELinux relabeling workaround
- Docker repo priority adjustments
- LM Studio AppImage sandbox permissions (chrome-sandbox setuid)

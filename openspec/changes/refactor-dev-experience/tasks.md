# Implementation Tasks: Refactored Developer Experience

## 1. Foundation: Directory Structure and Cleanup

- [ ] 1.1 Create new directory structure under `recipes/`: `recipes/dev/`, `recipes/virtualization/`, `recipes/security/`, `recipes/ai/`, `recipes/dotfiles/`, `recipes/system/`, `recipes/flatpaks/`
- [ ] 1.2 Create supporting directories: `files/scripts/`, `files/system/usr/lib/systemd/system/`, `files/system/usr/lib/tmpfiles.d/`, `files/system/etc/skel/.config/chezmoi/`, `files/system/etc/skel/.config/Code/User/`
- [ ] 1.3 Verify all parent directories exist in git
- [ ] 1.4 **CRITICAL:** Ensure no files are created in root `modules/` folder - that folder is for custom BlueBuild modules only (Nushell scripts)

## 2. System: Group Management (Version 2)

- [ ] 2.1 Create `files/scripts/setup-groups.sh` with version 2 logic (docker, libvirt, incus-admin groups)
- [ ] 2.2 Create `files/system/usr/lib/systemd/system/dx-groups.service` systemd unit
- [ ] 2.3 Create `files/system/usr/lib/tmpfiles.d/dx-groups.conf` for /etc/ublue directory
- [ ] 2.4 Create `recipes/system/groups.yml` using script module to run setup-groups.sh
- [ ] 2.5 Verify script handles: version checking, group appending from /usr/lib/group, wheel user enumeration

## 3. System: Cockpit Configuration

- [ ] 3.1 Create `recipes/system/cockpit.yml` with dnf module for all cockpit packages
- [ ] 3.2 Include packages: cockpit-system, cockpit-bridge, cockpit-machines, cockpit-podman, cockpit-ostree, cockpit-networkmanager, cockpit-selinux, cockpit-storaged, cockpit-kdump, cockpit-files
- [ ] 3.3 Verify against Aurora DX package list for completeness

## 4. System: Networking Workarounds

- [ ] 4.1 Create `recipes/system/networking.yml` with IP forwarding and iptable_nat setup
- [ ] 4.2 Add sysctl settings: net.ipv4.ip_forward=1, net.ipv6.conf.all.forwarding=1
- [ ] 4.3 Create `files/system/etc/modules-load.d/ip_tables.conf` with "iptable_nat" entry
- [ ] 4.4 Document as temporary override in file comments

## 5. System: Service Enables

- [ ] 5.1 Create `recipes/system/services.yml` with systemd module
- [ ] 5.2 Enable services: docker.socket, podman.socket, dx-groups.service, libvirt-workaround.service
- [ ] 5.3 Ensure libvirt-workaround.service uses proper ConditionPathIsDirectory checks

## 6. Development: Homebrew + Mise

- [ ] 6.1 Create `recipes/dev/brew.yml` with brew module
- [ ] 6.2 Configure: nofile-limits: true, brew-analytics: false, update-interval: 1d, upgrade-interval: 1d
- [ ] 6.3 Add mise to brew install list (runs after brew setup)

## 7. Development: VSCode + DevContainer CLI

- [ ] 7.1 Create `recipes/dev/vscode.yml` with dnf module
- [ ] 7.2 Add Microsoft repository to repos.files section
- [ ] 7.3 Install code package
- [ ] 7.4 Create `files/system/etc/skel/.config/Code/User/settings.json` with: window.titleBarStyle=custom, editor.fontFamily with nerd fonts, update.mode=none
- [ ] 7.5 Add script module to install @devcontainers/cli via npm globally
- [ ] 7.6 Ensure npm is available (via brew or system package)

## 8. Development: Docker CE

- [ ] 8.1 Create `recipes/dev/docker.yml` with dnf module
- [ ] 8.2 Add Docker CE repository URL to repos.files
- [ ] 8.3 Install packages: docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin, docker-compose-plugin, docker-model-plugin
- [ ] 8.4 Document that networking.yml must run before this module
- [ ] 8.5 Verify repo disable after install (temporary override pattern)

## 9. Development: Podman Extensions

- [ ] 9.1 Create `recipes/dev/podman.yml` with dnf module
- [ ] 9.2 Install: podman-compose, podman-tui, podman-machine, podmansh
- [ ] 9.3 Note: base podman is already in Bazzite

## 10. Virtualization: QEMU

- [ ] 10.1 Create `recipes/virtualization/qemu.yml` with dnf module
- [ ] 10.2 Install packages: qemu, qemu-img, qemu-system-x86-core, qemu-device-display-virtio-gpu, qemu-device-display-virtio-vga, qemu-user-binfmt, qemu-user-static, qemu-char-spice, qemu-device-usb-redirect
- [ ] 10.3 Cross-reference with Aurora DX 00-dx.sh for package list accuracy

## 11. Virtualization: libvirt + Tools

- [ ] 11.1 Create `recipes/virtualization/libvirt.yml` with dnf module
- [ ] 11.2 Install base packages: libvirt, libvirt-nss, virt-manager, virt-viewer, virt-install, virt-v2v
- [ ] 11.3 Add kcli via dnf module's repos.copr: name: karmab/kcli
- [ ] 11.4 Add podman-bootc via dnf module's repos.copr: name: gmaglione/podman-bootc
- [ ] 11.5 Install edk2-ovmf (UEFI firmware for VMs)
- [ ] 11.6 Create `files/system/usr/lib/systemd/system/libvirt-workaround.service` for SELinux relabeling

## 12. Virtualization: Incus

- [ ] 12.1 Create `recipes/virtualization/incus.yml` with dnf module
- [ ] 12.2 Install: incus, incus-agent, lxc
- [ ] 12.3 Document that incus-admin group is handled by groups module

## 13. Security: 1Password

- [ ] 13.1 Create `recipes/security/1password.yml` with bling module
- [ ] 13.2 Configure: install: 1password (includes GUI and op CLI)
- [ ] 13.3 Add 1Password repository to dnf repos if not handled by bling
- [ ] 13.4 Remove 1password from old recipes/common.yml location

## 14. AI: LM Studio - GPU Agnostic Base

- [ ] 14.1 Create `recipes/ai/lmstudio.yml` with script module
- [ ] 14.2 Download LM Studio AppImage from lmstudio.ai to /opt/lmstudio/
- [ ] 14.3 Extract AppImage with --appimage-extract
- [ ] 14.4 Set chrome-sandbox permissions: chown root:root, chmod 4755
- [ ] 14.5 Create desktop entry in /usr/share/applications/
- [ ] 14.6 Bootstrap lms CLI: ~/.lmstudio/bin/lms bootstrap
- [ ] 14.7 Document as temporary override (AppImage-based installation)

## 14b. AI: LM Studio - AMD/Intel Specific

- [ ] 14b.1 Create `recipes/ai/lmstudio-amd.yml` with dnf module
- [ ] 14b.2 Install clblast package
- [ ] 14b.3 Create symlinks for libclblast.so in /usr/local/lib/
- [ ] 14b.4 Document that this is for AMD/Intel GPUs only (not NVIDIA)

## 15. Dotfiles: Chezmoi Skeleton

- [ ] 15.1 Create `recipes/dotfiles/chezmoi.yml` with brew module
- [ ] 15.2 Install chezmoi via brew
- [ ] 15.3 Create `files/system/etc/skel/.config/chezmoi/chezmoi.toml` template:

  ```toml
  [data]
  # User-specific data - modify as needed

  # Source directory for dotfiles
  # Uncomment and set your repo after creating it:
  # sourceDir = "https://github.com/YOURNAME/dotfiles.git"

  # To initialize:
  #   chezmoi init https://github.com/YOURNAME/dotfiles.git
  #   chezmoi apply
  ```

- [ ] 15.4 Add README comment in file explaining next steps

## 16. Flatpaks: Development Tools

- [ ] 16.1 Create `recipes/flatpaks/dev.yml` with default-flatpaks module
- [ ] 16.2 Configure system scope with sh.loft.devpod
- [ ] 16.3 Add it.mijorus.gearlever (Gear Lever) for AppImage management
- [ ] 16.4 Ensure Flathub repo is configured (may need separate module if not in base)

## 17. Integration: DX Orchestrator

- [ ] 17.1 Create `recipes/dx.yml` as orchestrator using from-file: references (GPU-agnostic modules)
- [ ] 17.2 Create `recipes/dx-amd.yml` that includes dx.yml modules + ai/lmstudio-amd.yml for AMD/Intel GPUs
- [ ] 17.3 Order modules in dx.yml (GPU-agnostic):
  1. system/networking.yml (first - IP forwarding)
  2. system/groups.yml
  3. system/cockpit.yml
  4. dev/brew.yml
  5. dev/vscode.yml
  6. dev/docker.yml
  7. dev/podman.yml
  8. virtualization/qemu.yml
  9. virtualization/libvirt.yml
  10. virtualization/incus.yml
  11. security/1password.yml
  12. ai/lmstudio.yml
  13. dotfiles/chezmoi.yml
  14. system/services.yml
  15. flatpaks/dev.yml
- [ ] 17.3 Remove old recipes/dx.yml, recipes/dx/ directory, and files/system/etc/yum.repos.d/\*.repo files

## 18. Recipe Update

- [ ] 18.1 Update `recipes/recipe-bazzite.yml` for AMD/main image
- [ ] 18.2 For AMD/main: reference dx-amd.yml (includes dx.yml + ai/lmstudio-amd.yml)
- [ ] 18.3 Document NVIDIA variant: would reference dx.yml only (skipping AMD-specific)
- [ ] 18.4 Ensure fonts.yml and common.yml are still referenced (but remove 1password from common)
- [ ] 18.5 Verify signing module remains last
- [ ] 18.6 Update any from-file: paths that changed

## 19. Cleanup and Verification

- [ ] 19.1 Remove old files:
  - recipes/dx.yml (old monolithic)
  - recipes/dx/ directory and all subfiles
  - files/system/etc/yum.repos.d/1password.repo
  - files/system/etc/yum.repos.d/vscode.repo
  - files/system/etc/yum.repos.d/docker-ce.repo
  - files/scripts/preconfigure-dx.sh (if no longer needed)
  - files/system/usr/libexec/dx-groups (old version 1)
- [ ] 19.2 Verify no references to removed files in recipe-bazzite.yml
- [ ] 19.3 Check all YAML files with blue-build schema validation

## 20. Testing and Validation

- [ ] 20.1 Run local validation: `bluebuild validate recipes/recipe-bazzite.yml`
- [ ] 20.2 Verify no YAML syntax errors
- [ ] 20.3 Check all file references exist
- [ ] 20.4 Validate dnf module syntax against schema
- [ ] 20.5 Ensure all COPR URLs use %OS_VERSION% variable

## 21. Documentation

- [ ] 21.1 Update README.md with new module structure description
- [ ] 21.2 Add section explaining temporary overrides and what may change
- [ ] 21.3 Document LM Studio manual update process (AppImage-based)
- [ ] 21.4 Add migration guide for existing users (what groups they need to join)

## 22. Git Commit

- [ ] 22.1 Stage all new files
- [ ] 22.2 Remove old files from git tracking
- [ ] 22.3 Create conventional commit: `feat(dx): refactor developer experience with Aurora DX parity`
- [ ] 22.4 Verify clean git status

## 23. Post-Implementation Verification

- [ ] 23.1 Verify dx-groups.service runs without errors
- [ ] 23.2 Check that wheel users are added to all three groups (docker, libvirt, incus-admin)
- [ ] 23.3 Confirm docker.socket and podman.socket are enabled
- [ ] 23.4 Validate cockpit is accessible on port 9090
- [ ] 23.5 Test LM Studio launches with GPU acceleration
- [ ] 23.6 Verify lms CLI is available
- [ ] 23.7 Check that chezmoi template exists in /etc/skel/
- [ ] 23.8 Confirm devpod flatpak is installed system-wide

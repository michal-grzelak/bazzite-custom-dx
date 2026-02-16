# Implementation Tasks: Refactored Developer Experience

## 1. Foundation: Directory Structure and Cleanup

- [x] 1.1 Create new directory structure under `recipes/`: `recipes/dev/`, `recipes/virtualization/`, `recipes/security/`, `recipes/ai/`, `recipes/dotfiles/`, `recipes/system/`, `recipes/flatpaks/`
- [x] 1.2 Create supporting directories: `files/scripts/`, `files/system/usr/lib/systemd/system/`, `files/system/usr/lib/tmpfiles.d/`, `files/system/etc/skel/.config/chezmoi/`, `files/system/etc/skel/.config/Code/User/`
- [x] 1.3 Verify all parent directories exist in git
- [x] 1.4 **CRITICAL:** Ensure no files are created in root `modules/` folder - that folder is for custom BlueBuild modules only (Nushell scripts)

## 2. System: Group Management (Version 2)

- [x] 2.1 Create `files/scripts/setup-groups.sh` with version 2 logic (docker, libvirt, incus-admin groups)
- [x] 2.2 Create `files/system/usr/lib/systemd/system/dx-groups.service` systemd unit
- [x] 2.3 Create `files/system/usr/lib/tmpfiles.d/dx-groups.conf` for /etc/ublue directory
- [x] 2.4 Create `recipes/system/groups.yml` using script module to run setup-groups.sh
- [x] 2.5 Verify script handles: version checking, group appending from /usr/lib/group, wheel user enumeration

## 3. System: Cockpit Configuration

- [x] 3.1 Create `recipes/system/cockpit.yml` with dnf module for all cockpit packages
- [x] 3.2 Include packages: cockpit-system, cockpit-bridge, cockpit-machines, cockpit-podman, cockpit-ostree, cockpit-networkmanager, cockpit-selinux, cockpit-storaged, cockpit-kdump, cockpit-files
- [x] 3.3 Verify against Aurora DX package list for completeness

## 4. System: Networking Workarounds

- [x] 4.1 Create `recipes/system/networking.yml` with IP forwarding and iptable_nat setup
- [x] 4.2 Add sysctl settings: net.ipv4.ip_forward=1, net.ipv6.conf.all.forwarding=1
- [x] 4.3 Create `files/system/etc/modules-load.d/ip_tables.conf` with "iptable_nat" entry
- [x] 4.4 Document as temporary override in file comments

## 5. System: Service Enables

- [x] 5.1 Create `recipes/system/services.yml` with systemd module
- [x] 5.2 Enable services: docker.socket, podman.socket, dx-groups.service, libvirt-workaround.service
- [x] 5.3 Ensure libvirt-workaround.service uses proper ConditionPathIsDirectory checks

## 6. Development: Homebrew + Mise

- [x] 6.1 Create `recipes/dev/brew.yml` with brew module
- [x] 6.2 Configure: nofile-limits: true, brew-analytics: false, update-interval: 1d, upgrade-interval: 1d
- [x] 6.3 Add mise to brew install list (runs after brew setup)

## 7. Development: VSCode + DevContainer CLI

- [x] 7.1 Create `recipes/dev/vscode.yml` with dnf module
- [x] 7.2 Add Microsoft repository to repos.files section
- [x] 7.3 Install code package
- [x] 7.4 Create `files/system/etc/skel/.config/Code/User/settings.json` with: window.titleBarStyle=custom, editor.fontFamily with nerd fonts, update.mode=none
- [x] 7.5 Add script module to install @devcontainers/cli via npm globally
- [x] 7.6 Ensure npm is available (via brew or system package)

## 8. Development: Docker CE

- [x] 8.1 Create `recipes/dev/docker.yml` with dnf module
- [x] 8.2 Add Docker CE repository URL to repos.files
- [x] 8.3 Install packages: docker-ce, docker-ce-cli, containerd.io, docker-buildx-plugin, docker-compose-plugin, docker-model-plugin
- [x] 8.4 Document that networking.yml must run before this module
- [x] 8.5 Verify repo disable after install (temporary override pattern)

## 9. Development: Podman Extensions

- [x] 9.1 Create `recipes/dev/podman.yml` with dnf module
- [x] 9.2 Install: podman-compose, podman-tui, podman-machine, podmansh
- [x] 9.3 Note: base podman is already in Bazzite

## 10. Virtualization: QEMU

- [x] 10.1 Create `recipes/virtualization/qemu.yml` with dnf module
- [x] 10.2 Install packages: qemu, qemu-img, qemu-system-x86-core, qemu-device-display-virtio-gpu, qemu-device-display-virtio-vga, qemu-user-binfmt, qemu-user-static, qemu-char-spice, qemu-device-usb-redirect
- [x] 10.3 Cross-reference with Aurora DX 00-dx.sh for package list accuracy

## 11. Virtualization: libvirt + Tools

- [x] 11.1 Create `recipes/virtualization/libvirt.yml` with dnf module
- [x] 11.2 Install base packages: libvirt, libvirt-nss, virt-manager, virt-viewer, virt-install, virt-v2v
- [x] 11.3 Add kcli via dnf module's repos.copr: name: karmab/kcli
- [x] 11.4 Add podman-bootc via dnf module's repos.copr: name: gmaglione/podman-bootc
- [x] 11.5 Install edk2-ovmf (UEFI firmware for VMs)
- [x] 11.6 Create `files/system/usr/lib/systemd/system/libvirt-workaround.service` for SELinux relabeling

## 12. Virtualization: Incus

- [x] 12.1 Create `recipes/virtualization/incus.yml` with dnf module
- [x] 12.2 Install: incus, incus-agent, lxc
- [x] 12.3 Document that incus-admin group is handled by groups module

## 13. Security: 1Password

- [x] 13.1 Create `recipes/security/1password.yml` with bling module
- [x] 13.2 Configure: install: 1password (includes GUI and op CLI)
- [x] 13.3 Add 1Password repository to dnf repos if not handled by bling
- [x] 13.4 Remove 1password from old recipes/common.yml location

## 14. AI: LM Studio - GPU Agnostic Base

- [x] 14.1 Create `recipes/ai/lmstudio.yml` with script module
- [x] 14.2 Download LM Studio AppImage from lmstudio.ai to /opt/lmstudio/
- [x] 14.3 Extract AppImage with --appimage-extract
- [x] 14.4 Set chrome-sandbox permissions: chown root:root, chmod 4755
- [x] 14.5 Create desktop entry in /usr/share/applications/
- [x] 14.6 Bootstrap lms CLI: ~/.lmstudio/bin/lms bootstrap
- [x] 14.7 Document as temporary override (AppImage-based installation)

## 14b. AI: LM Studio - AMD/Intel Specific

- [x] 14b.1 Create `recipes/ai/lmstudio-amd.yml` with dnf module
- [x] 14b.2 Install clblast package
- [x] 14b.3 Create symlinks for libclblast.so in /usr/local/lib/
- [x] 14b.4 Document that this is for AMD/Intel GPUs only (not NVIDIA)

## 15. Dotfiles: Chezmoi Skeleton

- [x] 15.1 Create `recipes/dotfiles/chezmoi.yml` with brew module
- [x] 15.2 Install chezmoi via brew
- [x] 15.3 Create `files/system/etc/skel/.config/chezmoi/chezmoi.toml` template:

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

- [x] 15.4 Add README comment in file explaining next steps

## 16. Flatpaks: Development Tools

- [x] 16.1 Create `recipes/flatpaks/dev.yml` with default-flatpaks module
- [x] 16.2 Configure system scope with sh.loft.devpod
- [x] 16.3 Add it.mijorus.gearlever (Gear Lever) for AppImage management
- [x] 16.4 Ensure Flathub repo is configured (may need separate module if not in base)

## 17. Integration: DX Orchestrator

- [x] 17.1 Create `recipes/dx.yml` as orchestrator using from-file: references (GPU-agnostic modules)
- [x] 17.2 Create `recipes/dx-amd.yml` that includes dx.yml modules + ai/lmstudio-amd.yml for AMD/Intel GPUs
- [x] 17.3 Order modules in dx.yml (GPU-agnostic):
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
- [x] 17.3 Remove old recipes/dx.yml, recipes/dx/ directory, and files/system/etc/yum.repos.d/\*.repo files

## 18. Recipe Update

- [x] 18.1 Update `recipes/recipe-bazzite.yml` for AMD/main image
- [x] 18.2 For AMD/main: reference dx-amd.yml (includes dx.yml + ai/lmstudio-amd.yml)
- [x] 18.3 Document NVIDIA variant: would reference dx.yml only (skipping AMD-specific)
- [x] 18.4 Ensure fonts.yml and common.yml are still referenced (but remove 1password from common)
- [x] 18.5 Verify signing module remains last
- [x] 18.6 Update any from-file: paths that changed

## 19. Cleanup and Verification

- [x] 19.1 Remove old files:
  - recipes/dx.yml (old monolithic)
  - recipes/dx/ directory and all subfiles
  - files/system/etc/yum.repos.d/1password.repo
  - files/system/etc/yum.repos.d/vscode.repo
  - files/system/etc/yum.repos.d/docker-ce.repo
  - files/scripts/preconfigure-dx.sh (if no longer needed)
  - files/system/usr/libexec/dx-groups (old version 1)
- [x] 19.2 Verify no references to removed files in recipe-bazzite.yml
- [x] 19.3 Check all YAML files with blue-build schema validation

## 20. Testing and Validation

- [x] 20.1 Run local validation: `bluebuild validate recipes/recipe-bazzite.yml`
- [x] 20.2 Verify no YAML syntax errors
- [x] 20.3 Check all file references exist
- [x] 20.4 Validate dnf module syntax against schema
- [x] 20.5 Ensure all COPR URLs use %OS_VERSION% variable

## 21. Documentation

- [x] 21.1 Update README.md with new module structure description
- [x] 21.2 Add section explaining temporary overrides and what may change
- [x] 21.3 Document LM Studio manual update process (AppImage-based)
- [x] 21.4 Add migration guide for existing users (what groups they need to join)

## 22. Git Commit

- [x] 22.1 Stage all new files
- [x] 22.2 Remove old files from git tracking
- [x] 22.3 Create conventional commit: `feat(dx): refactor developer experience with Aurora DX parity`
- [x] 22.4 Verify clean git status

## 23. Post-Implementation Verification

- [ ] 23.1 Verify dx-groups.service runs without errors
- [ ] 23.2 Check that wheel users are added to all three groups (docker, libvirt, incus-admin)
- [ ] 23.3 Confirm docker.socket and podman.socket are enabled
- [ ] 23.4 Validate cockpit is accessible on port 9090
- [ ] 23.5 Test LM Studio launches with GPU acceleration
- [ ] 23.6 Verify lms CLI is available
- [ ] 23.7 Check that chezmoi template exists in /etc/skel/
- [ ] 23.8 Confirm devpod flatpak is installed system-wide

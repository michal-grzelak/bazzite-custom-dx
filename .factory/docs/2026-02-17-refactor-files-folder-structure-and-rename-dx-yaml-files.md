## Refactoring Plan

### 1. Move existing files from `files/` to `files/dev/`

| Current Location | New Location |
|------------------|---------------|
| `files/usr/libexec/dx-docker-groups` | `files/dev/usr/libexec/dx-docker-groups` |
| `files/usr/libexec/dx-libvirt-groups` | `files/dev/usr/libexec/dx-libvirt-groups` |
| `files/usr/libexec/dx-incus-groups` | `files/dev/usr/libexec/dx-incus-groups` |
| `files/systemd/system/dx-docker-groups.service` | `files/dev/usr/lib/systemd/system/dx-docker-groups.service` |
| `files/systemd/system/dx-libvirt-groups.service` | `files/dev/usr/lib/systemd/system/dx-libvirt-groups.service` |
| `files/systemd/system/dx-incus-groups.service` | `files/dev/usr/lib/systemd/system/dx-incus-groups.service` |
| `files/systemd/system/libvirt-workaround.service` | `files/dev/usr/lib/systemd/system/libvirt-workaround.service` |
| `files/dnf/vscode.repo` | `files/dev/etc/yum.repos.d/vscode.repo` |
| `files/etc/modules-load.d/ip_tables.conf` | `files/dev/etc/modules-load.d/ip_tables.conf` |
| `files/etc/skel/.config/chezmoi/chezmoi.toml` | `files/dev/etc/skel/.config/chezmoi/chezmoi.toml` |
| `files/etc/skel/.config/Code/User/settings.json` | `files/dev/etc/skel/.config/Code/User/settings.json` |

### 2. Create NEW missing files from Aurora DX

| New File | Content |
|----------|---------|
| `files/dev/usr/lib/sysctl.d/docker-ce.conf` | `net.ipv4.ip_forward=1` - Required for Docker-in-Docker |
| `files/dev/usr/lib/systemd/system/incus-workaround.service` | Aurora's incus-workaround.service |
| `files/dev/usr/lib/systemd/system/swtpm-workaround.service` | Aurora's swtpm-workaround.service |
| `files/dev/usr/lib/tmpfiles.d/incus-workaround.conf` | Creates /var/lib/lxcfs for Incus |
| `files/dev/usr/lib/tmpfiles.d/swtpm-workaround.conf` | Creates /run/tpm for TPM emulation |
| `files/dev/etc/profile.d/vscode-aurora-profile.sh` | VSCode shell integration |
| `files/dev/usr/share/ublue-os/user-setup.hooks.d/10-vscode.sh` | VSCode user setup hook |

### 3. Update module YAML files to reference new paths

- Update all `source:` paths in recipe modules to point to new `dev/` location
- Update systemd service paths

### 4. Rename dx YAML files to dev

| Current | New |
|---------|-----|
| `recipes/dx.yml` | `recipes/dev.yml` |
| `recipes/dx-amd.yml` | `recipes/dev-amd.yml` |

### 5. Update recipe-bazzite.yml references

- Change `from-file: dx-amd.yml` to `from-file: dev-amd.yml`

### Verification with Aurora:

| Component | Current Repo | Aurora DX | Status |
|-----------|-------------|-----------|--------|
| Docker CE | ✓ | ✓ | Match |
| QEMU | ✓ | ✓ | Match |
| Incus | ✓ | ✓ | Match |
| Libvirt | ✓ | ✓ | Match |
| Cockpit | ✓ (10 pkgs) | ✓ (8 pkgs) | Current has extras |
| **docker-ce.conf** | ✗ Missing | ✓ | **Needs to be added** |
| **incus-workaround** | ✗ Missing | ✓ | **Needs to be added** |
| **swtpm-workaround** | ✗ Missing | ✓ | **Needs to be added** |
| Group scripts | Separate | Combined | **Current is more modular** |
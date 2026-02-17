## Reorganize files/dev by module and fix source paths

### Files to reorganize:

**Docker module (`recipes/dev/docker.yml`):**
- Move to: `files/dev/docker/usr/libexec/dx-docker-groups`
- Move to: `files/dev/docker/usr/lib/sysctl.d/docker-ce.conf`
- Move to: `files/dev/docker/usr/lib/systemd/system/dx-docker-groups.service`

**Libvirt module (`recipes/virtualization/libvirt.yml`):**
- Move to: `files/dev/libvirt/usr/libexec/dx-libvirt-groups`
- Move to: `files/dev/libvirt/usr/lib/tmpfiles.d/libvirt-workaround.conf`
- Move to: `files/dev/libvirt/usr/lib/systemd/system/dx-libvirt-groups.service`
- Move to: `files/dev/libvirt/usr/lib/systemd/system/libvirt-workaround.service`
- Move to: `files/dev/libvirt/usr/lib/systemd/system/swtpm-workaround.service`

**Incus module (`recipes/virtualization/incus.yml`):**
- Move to: `files/dev/incus/usr/libexec/dx-incus-groups`
- Move to: `files/dev/incus/usr/lib/systemd/system/dx-incus-groups.service`
- Move to: `files/dev/incus/usr/lib/systemd/system/incus-workaround.service`

**Networking module (`recipes/system/networking.yml`):**
- Move to: `files/dev/networking/etc/modules-load.d/ip_tables.conf`

**Chezmoi module (`recipes/dotfiles/chezmoi.yml`):**
- Move to: `files/dev/chezmoi/etc/skel/.config/chezmoi/chezmoi.toml`

**VSCode module (`recipes/dev/vscode.yml`):**
- Move to: `files/dev/vscode/etc/skel/.config/Code/User/settings.json`

### Module source path updates:

1. **docker.yml**: `usr/libexec/...` → `dev/docker/usr/libexec/...`, `usr/lib/sysctl.d/...` → `dev/docker/usr/lib/sysctl.d/...`, `usr/lib/systemd/system/...` → `dev/docker/usr/lib/systemd/system/...`

2. **libvirt.yml**: `usr/lib/tmpfiles.d/...` → `dev/libvirt/usr/lib/tmpfiles.d/...`, `usr/libexec/...` → `dev/libvirt/usr/libexec/...`, `usr/lib/systemd/system/...` → `dev/libvirt/usr/lib/systemd/system/...`

3. **incus.yml**: `usr/libexec/...` → `dev/incus/usr/libexec/...`, `usr/lib/systemd/system/...` → `dev/incus/usr/lib/systemd/system/...`

4. **networking.yml**: `etc/modules-load.d/...` → `dev/networking/etc/modules-load.d/...`

5. **chezmoi.yml**: `system/etc/skel/...` → `dev/chezmoi/etc/skel/...`

6. **vscode.yml**: add file source for `etc/skel/.config/Code/User/settings.json` → `dev/vscode/etc/skel/.config/Code/User/settings.json`
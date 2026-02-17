## Summary

Three fixes needed:
1. Split `dx-groups.service` into dedicated services per app (docker, libvirt, incus)
2. Move services from `recipes/system/services.yml` to their respective modules
3. Remove non-modular `files/system` copy from `recipe-bazzite.yml` and reorganize files to appropriate modules

---

## Fix 1: Split dx-groups into per-app services

**Current state:**
- `recipes/system/groups.yml` creates single `dx-groups.service` handling docker + libvirt + incus-admin groups in one script

**Target state:** Each app module has its own group service.

### Implementation:

1. **Create 3 separate service files** in `files/system/usr/lib/systemd/system/`:
   - `dx-docker-groups.service`
   - `dx-libvirt-groups.service`
   - `dx-incus-groups.service`

2. **Create 3 separate scripts** in `files/scripts/`:
   - `dx-docker-groups`
   - `dx-libvirt-groups`
   - `dx-incus-groups`

3. **Update `recipes/dev/docker.yml`** - add:
   - `files` module: copy dx-docker-groups script and service
   - `systemd` module: enable dx-docker-groups.service
   - Add `docker.socket` enable (move from services.yml)

4. **Update `recipes/virtualization/libvirt.yml`** - add:
   - `files` module: copy dx-libvirt-groups script and service (keep existing libvirt-workaround)
   - `systemd` module: enable dx-libvirt-groups.service (keep existing libvirt-workaround.service)
   - Already has libvirt-workaround.service enabled in services.yml - remove from there

5. **Update `recipes/virtualization/incus.yml`** - add:
   - `files` module: copy dx-incus-groups script and service
   - `systemd` module: enable dx-incus-groups.service

6. **Update `recipes/system/groups.yml`** - simplify:
   - Remove dx-groups.service reference
   - Keep only the tmpfile for /etc/ublue directory (or move to tmpfiles module)

7. **Delete old files**:
   - `files/scripts/setup-groups.sh`
   - `files/system/usr/lib/systemd/system/dx-groups.service`

---

## Fix 2: Move services from services.yml to appropriate modules

**Current state:**
- `recipes/system/services.yml` enables:
  - docker.socket
  - podman.socket
  - libvirt-workaround.service

**Target state:** Move each to its own module.

### Implementation:

| Service | Current location | New location |
|---------|------------------|--------------|
| docker.socket | services.yml | recipes/dev/docker.yml |
| podman.socket | services.yml | recipes/dev/podman.yml |
| libvirt-workaround.service | services.yml | recipes/virtualization/libvirt.yml |

1. **Update `recipes/dev/docker.yml`**:
   ```yaml
   - type: systemd
     system:
       enabled:
         - docker.socket
   ```

2. **Update `recipes/dev/podman.yml`** (create if needed or update existing):
   ```yaml
   - type: systemd
     system:
       enabled:
         - podman.socket
   ```

3. **Update `recipes/virtualization/libvirt.yml`**:
   - Already has libvirt-workaround.service - verify it's enabled there

4. **Delete `recipes/system/services.yml`** after moving all services

---

## Fix 3: Remove non-modular file copy and reorganize

**Current state:**
- `recipe-bazzite.yml` copies entire `files/system/` to `/`:
  ```yaml
  - type: files
    files:
      - source: system
        destination: /
  ```

**Files currently in `files/system/`:**

| File | Current | Should be in |
|------|---------|--------------|
| `etc/skel/.config/Code/User/settings.json` | system/ | recipes/dev/vscode.yml |
| `etc/skel/.config/chezmoi/chezmoi.toml` | system/ | recipes/dotfiles/chezmoi.yml |
| `etc/modules-load.d/ip_tables.conf` | system/ | recipes/system/networking.yml |
| `usr/lib/sysctl.d/docker-ce.conf` | system/ | DELETE (not needed) |
| `usr/lib/tmpfiles.d/dx-groups.conf` | system/ | recipes/system/groups.yml |
| `usr/lib/tmpfiles.d/libvirt-workaround.conf` | system/ | recipes/virtualization/libvirt.yml |
| `usr/lib/systemd/system/dx-groups.service` | system/ | DELETE (split into per-app) |
| `usr/lib/systemd/system/libvirt-workaround.service` | system/ | Already in libvirt.yml |

### Implementation:

1. **Delete obsolete files:**
   - `files/system/usr/lib/sysctl.d/docker-ce.conf` - IP forward not needed
   - `files/system/usr/lib/systemd/system/dx-groups.service` - replaced by per-app services
   - `files/system/usr/lib/tmpfiles.d/dx-groups.conf` - /etc/ublue can be created by each service or use tmpfiles module

2. **Move files to appropriate modules:**

   a. **recipes/dev/vscode.yml** - add:
   ```yaml
   - type: files
     files:
       - source: etc/skel/.config/Code/User/settings.json
         destination: /etc/skel/.config/Code/User/settings.json
   ```

   b. **recipes/dotfiles/chezmoi.yml** - add:
   ```yaml
   - type: files
     files:
       - source: etc/skel/.config/chezmoi/chezmoi.toml
         destination: /etc/skel/.config/chezmoi/chezmoi.toml
   ```

   c. **recipes/system/networking.yml** - add:
   ```yaml
   - type: files
     files:
       - source: etc/modules-load.d/ip_tables.conf
         destination: /etc/modules-load.d/ip_tables.conf
   ```

   d. **recipes/virtualization/libvirt.yml** - add tmpfile:
   ```yaml
   - type: files
     files:
       - source: usr/lib/tmpfiles.d/libvirt-workaround.conf
         destination: /usr/lib/tmpfiles.d/libvirt-workaround.conf
   ```

3. **Update `recipes/system/groups.yml`** - if keeping tmpfile:
   ```yaml
   - type: files
     files:
       - source: usr/lib/tmpfiles.d/dx-groups.conf
         destination: /usr/lib/tmpfiles.d/dx-groups.conf
   ```

4. **Remove from `recipe-bazzite.yml`:**
   ```yaml
   # DELETE this entire block:
   - type: files
     files:
       - source: system
         destination: /
   ```

---

## Complete Change Summary

### New files to create:
- `files/scripts/dx-docker-groups`
- `files/scripts/dx-libvirt-groups`
- `files/scripts/dx-incus-groups`
- `files/system/usr/lib/systemd/system/dx-docker-groups.service`
- `files/system/usr/lib/systemd/system/dx-libvirt-groups.service`
- `files/system/usr/lib/systemd/system/dx-incus-groups.service`

### Files to modify:
| File | Changes |
|------|---------|
| `recipes/dev/docker.yml` | Add group service, socket enable, vscode settings (move from system/) |
| `recipes/dev/podman.yml` | Add podman.socket enable |
| `recipes/virtualization/libvirt.yml` | Add libvirt group service, tmpfile |
| `recipes/virtualization/incus.yml` | Add incus group service |
| `recipes/system/groups.yml` | Remove dx-groups, keep tmpfile only |
| `recipes/system/networking.yml` | Add ip_tables.conf file |
| `recipes/dotfiles/chezmoi.yml` | Add skel chezmoi config |
| `recipe-bazzite.yml` | Remove the files/system copy block |

### Files to delete:
- `files/scripts/setup-groups.sh`
- `files/system/usr/lib/systemd/system/dx-groups.service`
- `files/system/usr/lib/sysctl.d/docker-ce.conf`
- `files/system/usr/lib/tmpfiles.d/dx-groups.conf` (or move to groups module)
- `recipes/system/services.yml`

### Networking validation:
- Aurora DX has no special networking config for Docker
- IP forwarding sysctl not needed (already removed module, now delete sysctl file too)
- iptables_nat module loading may not be needed but kept as valid `files` module
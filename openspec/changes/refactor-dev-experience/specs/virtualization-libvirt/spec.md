## ADDED Requirements

### Requirement: libvirt installed
The system SHALL install libvirt for virtualization management.

#### Scenario: libvirt installation
- **WHEN** the image is built
- **THEN** libvirt package is installed
- **THEN** libvirt-nss package is installed for name resolution

### Requirement: virt-manager installed
The system SHALL install virt-manager for GUI VM management.

#### Scenario: virt-manager installation
- **WHEN** the image is built
- **THEN** virt-manager package is installed
- **THEN** virt-manager desktop entry is available

### Requirement: virt-viewer installed
The system SHALL install virt-viewer for VM display access.

#### Scenario: virt-viewer installation
- **WHEN** the image is built
- **THEN** virt-viewer package is installed

### Requirement: virt-install installed
The system SHALL install virt-install for command-line VM creation.

#### Scenario: virt-install installation
- **WHEN** the image is built
- **THEN** virt-install package is installed

### Requirement: virt-v2v installed
The system SHALL install virt-v2v for VM migration and conversion.

#### Scenario: virt-v2v installation
- **WHEN** the image is built
- **THEN** virt-v2v package is installed

### Requirement: kcli installed from COPR
The system SHALL install kcli from karmab/kcli COPR for KVM management using dnf module's native COPR support.

#### Scenario: kcli installation
- **WHEN** the image is built
- **THEN** karmab/kcli COPR is configured via dnf module's repos.copr
- **THEN** kcli package is installed from the COPR repository
- **THEN** repository is cleaned up per dnf module behavior

### Requirement: podman-bootc installed from COPR
The system SHALL install podman-bootc from gmaglione/podman-bootc COPR using dnf module's native COPR support.

#### Scenario: podman-bootc installation
- **WHEN** the image is built
- **THEN** gmaglione/podman-bootc COPR is configured via dnf module's repos.copr
- **THEN** podman-bootc package is installed from the COPR repository
- **THEN** repository is cleaned up per dnf module behavior

### Requirement: libvirt workaround service installed
The system SHALL install a workaround service for libvirt SELinux relabeling.

#### Scenario: Workaround service installation
- **WHEN** the image is built
- **THEN** libvirt-workaround.service is installed
- **THEN** service runs restorecon on /var/log/libvirt/ and /var/lib/libvirt/

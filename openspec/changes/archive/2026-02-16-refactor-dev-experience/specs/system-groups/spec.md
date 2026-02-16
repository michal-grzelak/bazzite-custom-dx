## ADDED Requirements

### Requirement: Group setup service installed
The system SHALL install a versioned group setup service for managing user groups.

#### Scenario: Service installation
- **WHEN** the image is built
- **THEN** dx-groups systemd service is installed
- **THEN** service type is oneshot
- **THEN** service has restart on failure configuration

### Requirement: Group setup script version 2 installed
The system SHALL install the version 2 group setup script with incus-admin support.

#### Scenario: Script installation
- **WHEN** the image is built
- **THEN** /usr/libexec/dx-groups script is installed
- **THEN** script version is set to 2
- **THEN** script tracks state in /etc/ublue/dx-groups

### Requirement: Wheel users added to docker group
The system SHALL add all wheel users to the docker group.

#### Scenario: Docker group assignment
- **WHEN** dx-groups service runs
- **THEN** all wheel group members are added to docker group
- **THEN** docker group is created if missing

### Requirement: Wheel users added to libvirt group
The system SHALL add all wheel users to the libvirt group.

#### Scenario: Libvirt group assignment
- **WHEN** dx-groups service runs
- **THEN** all wheel group members are added to libvirt group
- **THEN** libvirt group is created if missing

### Requirement: Wheel users added to incus-admin group
The system SHALL add all wheel users to the incus-admin group.

#### Scenario: Incus-admin group assignment
- **WHEN** dx-groups service runs
- **THEN** all wheel group members are added to incus-admin group
- **THEN** incus-admin group is appended from /usr/lib/group if missing

### Requirement: Group setup service enabled
The system SHALL enable the group setup service to run on boot.

#### Scenario: Service enabled
- **WHEN** the system boots
- **THEN** dx-groups.service is enabled
- **THEN** service runs once per boot or when version changes

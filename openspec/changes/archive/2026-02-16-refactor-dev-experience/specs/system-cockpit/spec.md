## ADDED Requirements

### Requirement: Cockpit base installed
The system SHALL install Cockpit web-based server management.

#### Scenario: Cockpit installation
- **WHEN** the image is built
- **THEN** cockpit-system is installed
- **THEN** cockpit-bridge is installed

### Requirement: Cockpit Machines plugin installed
The system SHALL install Cockpit Machines plugin for VM management.

#### Scenario: Machines plugin installation
- **WHEN** the image is built
- **THEN** cockpit-machines is installed

### Requirement: Cockpit Podman plugin installed
The system SHALL install Cockpit Podman plugin for container management.

#### Scenario: Podman plugin installation
- **WHEN** the image is built
- **THEN** cockpit-podman is installed

### Requirement: Cockpit OSTree plugin installed
The system SHALL install Cockpit OSTree plugin for system updates.

#### Scenario: OSTree plugin installation
- **WHEN** the image is built
- **THEN** cockpit-ostree is installed

### Requirement: Cockpit additional plugins installed
The system SHALL install additional Cockpit plugins.

#### Scenario: Additional plugins installation
- **WHEN** the image is built
- **THEN** cockpit-networkmanager is installed
- **THEN** cockpit-selinux is installed
- **THEN** cockpit-storaged is installed
- **THEN** cockpit-kdump is installed
- **THEN** cockpit-files is installed

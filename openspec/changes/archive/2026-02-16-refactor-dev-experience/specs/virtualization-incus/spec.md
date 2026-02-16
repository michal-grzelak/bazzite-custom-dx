## ADDED Requirements

### Requirement: Incus installed
The system SHALL install Incus for system container and VM management.

#### Scenario: Incus installation
- **WHEN** the image is built
- **THEN** incus package is installed
- **THEN** incus-agent package is installed

### Requirement: LXC installed
The system SHALL install LXC for low-level container support.

#### Scenario: LXC installation
- **WHEN** the image is built
- **THEN** lxc package is installed

### Requirement: Incus group management
The system SHALL ensure wheel users are added to incus-admin group.

#### Scenario: Incus group setup
- **WHEN** dx-groups service runs
- **THEN** incus-admin group is created if missing
- **THEN** wheel users are added to incus-admin group

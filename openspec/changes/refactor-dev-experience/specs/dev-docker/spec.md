## ADDED Requirements

### Requirement: Docker CE installed from official repository
The system SHALL install Docker Community Edition from the official Docker repository.

#### Scenario: Docker installation
- **WHEN** the image is built
- **THEN** docker-ce.repo is added to dnf repos
- **THEN** docker-ce package is installed
- **THEN** docker-ce-cli package is installed
- **THEN** containerd.io package is installed

### Requirement: Docker Buildx plugin installed
The system SHALL install Docker Buildx plugin for multi-platform builds.

#### Scenario: Buildx installation
- **WHEN** the image is built
- **THEN** docker-buildx-plugin package is installed
- **THEN** docker buildx command is available

### Requirement: Docker Compose plugin installed
The system SHALL install Docker Compose plugin.

#### Scenario: Compose plugin installation
- **WHEN** the image is built
- **THEN** docker-compose-plugin package is installed
- **THEN** docker compose command is available

### Requirement: Docker Model plugin installed
The system SHALL install Docker Model plugin for AI model management.

#### Scenario: Model plugin installation
- **WHEN** the image is built
- **THEN** docker-model-plugin package is installed

### Requirement: IP forwarding enabled for Docker networking
The system SHALL enable IP forwarding before Docker installation to prevent LXC networking conflicts.

#### Scenario: IP forwarding configuration
- **WHEN** the image is built
- **THEN** net.ipv4.ip_forward=1 is set in sysctl
- **THEN** net.ipv6.conf.all.forwarding=1 is set in sysctl
- **THEN** sysctl -p is executed before Docker installation

### Requirement: iptable_nat module loaded for docker-in-docker
The system SHALL load iptable_nat kernel module for docker-in-docker support.

#### Scenario: iptable_nat module loaded
- **WHEN** the image is built
- **THEN** /etc/modules-load.d/ip_tables.conf contains "iptable_nat"

### Requirement: Docker socket enabled
The system SHALL enable Docker socket for API access.

#### Scenario: Docker socket enabled
- **WHEN** the system boots
- **THEN** docker.socket systemd service is enabled

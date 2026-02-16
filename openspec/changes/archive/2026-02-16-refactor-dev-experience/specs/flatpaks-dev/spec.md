## ADDED Requirements

### Requirement: DevPod Flatpak installed system-wide
The system SHALL install DevPod Flatpak for remote development environments.

#### Scenario: DevPod installation
- **WHEN** the image is built
- **THEN** sh.loft.devpod is installed via default-flatpaks module
- **THEN** installation scope is system
- **THEN** users cannot remove the flatpak

### Requirement: Gear Lever Flatpak installed system-wide
The system SHALL install Gear Lever Flatpak for AppImage management.

#### Scenario: Gear Lever installation
- **WHEN** the image is built
- **THEN** it.mijorus.gearlever is installed via default-flatpaks module
- **THEN** installation scope is system
- **THEN** users cannot remove the flatpak
- **THEN** Gear Lever can be used to manage AppImages including desktop integration and updates

### Requirement: Flathub configured
The system SHALL configure Flathub as the default Flatpak repository.

#### Scenario: Flathub configuration
- **WHEN** the image is built
- **THEN** flathub.flatpakrepo is added to /etc/flatpak/remotes.d/
- **THEN** both system and user scopes are available

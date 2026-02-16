## ADDED Requirements

### Requirement: Visual Studio Code installed from Microsoft repository
The system SHALL install Visual Studio Code from the official Microsoft repository.

#### Scenario: VSCode installation
- **WHEN** the image is built
- **THEN** Microsoft repository is added to dnf repos
- **THEN** code package is installed
- **THEN** VSCode desktop entry is available

### Requirement: DevContainer CLI installed
The system SHALL install the DevContainer CLI for VS Code remote containers support.

#### Scenario: DevContainer CLI installation
- **WHEN** the image is built
- **THEN** @devcontainers/cli is installed via npm globally
- **THEN** devcontainer command is available in PATH

### Requirement: VSCode default settings configured
The system SHALL provide default VSCode settings optimized for the environment.

#### Scenario: Default settings applied
- **WHEN** a new user is created
- **THEN** VSCode settings.json is copied to ~/.config/Code/User/
- **THEN** window.titleBarStyle is set to "custom"
- **THEN** editor font includes Cascadia Code and Symbols Nerd Font Mono
- **THEN** update.mode is set to "none"

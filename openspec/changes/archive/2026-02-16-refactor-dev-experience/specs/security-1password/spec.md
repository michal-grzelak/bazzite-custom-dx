## ADDED Requirements

### Requirement: 1Password GUI installed
The system SHALL install 1Password password manager GUI application.

#### Scenario: 1Password GUI installation
- **WHEN** the image is built
- **THEN** 1password is installed via the bling module
- **THEN** 1Password desktop entry is available

### Requirement: 1Password CLI installed
The system SHALL install the 1Password CLI tool (op).

#### Scenario: 1Password CLI installation
- **WHEN** the image is built
- **THEN** op CLI binary is installed
- **THEN** op command is available in PATH

### Requirement: 1Password repository configured
The system SHALL configure the 1Password RPM repository.

#### Scenario: Repository configuration
- **WHEN** the image is built
- **THEN** 1Password repository is added to dnf repos
- **THEN** repository GPG key is configured

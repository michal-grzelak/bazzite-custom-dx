## ADDED Requirements

### Requirement: Chezmoi installed
The system SHALL install chezmoi for dotfile management.

#### Scenario: Chezmoi installation
- **WHEN** the image is built
- **THEN** chezmoi is installed via the brew module
- **THEN** chezmoi binary is available in PATH

### Requirement: Chezmoi configuration skeleton created
The system SHALL create a skeleton configuration for future dotfiles repository.

#### Scenario: Skeleton configuration
- **WHEN** the image is built
- **THEN** /etc/skel/.config/chezmoi/chezmoi.toml is created as a template
- **THEN** template includes placeholder for source directory
- **THEN** comments indicate where user should configure their repo

### Requirement: Chezmoi documentation provided
The system SHALL provide documentation for setting up chezmoi with a real repository.

#### Scenario: Documentation provided
- **WHEN** the image is built
- **THEN** a README or comment exists explaining:
- **THEN** how to initialize chezmoi with a git repository
- **THEN** recommended repository structure
- **THEN** commands to apply dotfiles on new system

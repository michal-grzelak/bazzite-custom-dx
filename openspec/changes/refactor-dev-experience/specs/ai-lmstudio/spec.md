## ADDED Requirements

### Requirement: LM Studio AppImage installed

The system SHALL install LM Studio as an AppImage for local LLM development.

#### Scenario: LM Studio AppImage installation

- **WHEN** the image is built
- **THEN** LM Studio AppImage is downloaded to /opt/lmstudio/
- **THEN** AppImage is made executable
- **THEN** Desktop entry is created for application menu

### Requirement: LM Studio CLI (lms) bootstrapped

The system SHALL bootstrap the LM Studio CLI (lms) for command-line model management.

#### Scenario: LMS CLI bootstrap

- **WHEN** the image is built
- **THEN** lms bootstrap is executed
- **THEN** lms command is available in user PATH (~/.lmstudio/bin/)
- **THEN** lms is linked to system PATH

### Requirement: Chrome sandbox permissions configured

The system SHALL configure chrome-sandbox permissions for LM Studio browser sandbox security.

#### Scenario: Sandbox permissions

- **WHEN** the image is built
- **THEN** chrome-sandbox is owned by root:root
- **THEN** chrome-sandbox has setuid bit (4755 permissions)

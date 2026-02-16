# AGENTS.md

## Project Overview

This is a custom Fedora Atomic OS image built with BlueBuild. It extends Bazzite (a gaming-focused Fedora Atomic variant) with personal developer tools and configurations.

**Key Characteristics:**
- **Not a traditional application** - This builds bootable system images, not deployable code
- **Declarative configuration** - Image is defined entirely through YAML recipe files
- **OSTree native containers** - Uses Fedora Atomic's immutable infrastructure approach

## Technology Stack

- **BlueBuild** - Tool for building custom Fedora Atomic images
- **Bazzite** - Base image (Fedora Atomic with gaming optimizations)
- **YAML** - Recipe and module configuration files
- **GitHub Actions** - CI/CD for automated builds
- **Sigstore cosign** - Image signing

## Schemas (Source of Truth)

All YAML files follow BlueBuild schemas. Reference these for structure and conventions:

- Recipe: `https://schema.blue-build.org/recipe-v1.json`
- Modules: `https://schema.blue-build.org/module-stage-list-v1.json`

## Build Commands

This project has **no local build/test commands** - images are built via GitHub Actions.

**Local validation:**
- Validate YAML syntax against BlueBuild schemas
- Use `bluebuild` CLI if installed: `bluebuild build recipes/recipe-bazzite.yml`

**CI/CD:**
- Builds trigger automatically on push to main
- Images published to: `ghcr.io/michal-grzelak/bazzite-custom-dx`

## Code Style Guidelines

- **Conventional commits** - Use standard commit message format
- **YAML formatting** - Consistent indentation, validated against schemas
- **Modular design** - Prefer reusable module configurations

## Important Notes

- **Repository structure is being refactored** - Do not hardcode specific file paths
- **No secrets in configs** - All sensitive data (signing keys) are handled via GitHub secrets
- **Immutable infrastructure** - Changes are baked into images, not applied at runtime

## Security Considerations

- Images are signed with cosign. Public key available at `cosign.pub`.
- Never commit sensitive configuration to YAML files
- All builds run in GitHub Actions with isolated environments

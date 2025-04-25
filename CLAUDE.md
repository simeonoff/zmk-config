# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

- Initialize: `just init` - Setup the west environment
- Build: `just build <target>` - Build for specified target (use "all" for all targets)
- List targets: `just list` - Show available build targets
- Clean: `just clean` - Remove build artifacts

## Code Style Guidelines

- **Keymap files**: Maintain consistent layer organization with clear labels and visual separators
- **Shield definitions**: Follow ZMK shield configuration patterns with required Kconfig and overlay files
- **Naming**: Use lowercase with underscores for files and kebab-case for shield names
- **DTSi Files**: Follow standard Devicetree format with proper indentation (2 spaces)
- **Macros**: Define in macros.dtsi with clear labels and descriptive comments
- **Behaviors**: Configure in behaviors.dtsi using standard ZMK behavior syntax

## Commit Format

- Follow conventional commits format: `type: description`
- Types: feat, fix, refactor, docs, style, test, chore
- Keep commit messages concise and descriptive
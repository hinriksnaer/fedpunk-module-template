#!/usr/bin/env fish
# ============================================================================
# Template Module CLI - Demonstrates Best Practices
# ============================================================================
# This template shows the minimal pattern for Fedpunk module CLIs.
# Features demonstrated:
#   - Auto-discovery CLI pattern (no boilerplate!)
#   - Config file management with validation
#   - Interactive updates with gum
#   - Clear error handling and user feedback
#
# Note: cli-dispatch is pre-loaded by fedpunk, no manual sourcing needed!
# ============================================================================

# ============================================================================
# Main Command - Entry Point
# ============================================================================
# Just one line! cli-auto-dispatch handles everything:
#   - Discovers all functions in this directory as subcommands
#   - Generates help from --description flags
#   - Routes to the right subcommand
# ============================================================================

function template --description "Template module configuration management"
    cli-auto-dispatch template $argv
end

# ============================================================================
# Subcommands - Clean Function Definitions
# ============================================================================
# Each function = one subcommand. The pattern is simple:
#   1. Define function with --description
#   2. Handle --help if you want detailed docs
#   3. Implement your logic
# ============================================================================

function show --description "Display current configuration value"
    if contains -- "$argv[1]" --help -h
        echo "Display the current example_value from config"
        echo ""
        echo "Usage: fedpunk template show"
        echo ""
        echo "Reads the value from ~/.config/template/config.conf"
        return 0
    end

    set -l config_file "$HOME/.config/template/config.conf"

    if not test -f "$config_file"
        echo "Config file not found: $config_file"
        echo "Run 'fedpunk module deploy template' to initialize"
        return 1
    end

    # Read value from config file
    set -l value (grep "^example_value=" "$config_file" 2>/dev/null | cut -d'=' -f2-)

    if test -z "$value"
        echo "No value set in config"
        return 1
    end

    echo "Current value: $value"
end

function update --description "Update configuration value interactively"
    if contains -- "$argv[1]" --help -h
        echo "Update the example_value in config"
        echo ""
        echo "Usage: fedpunk template update [value]"
        echo ""
        echo "If value is not provided, prompts interactively using gum."
        return 0
    end

    set -l config_file "$HOME/.config/template/config.conf"
    set -l new_value $argv[1]

    # Ensure config directory exists
    mkdir -p (dirname "$config_file")

    # If no value provided, prompt with gum
    if test -z "$new_value"
        if not command -v gum >/dev/null
            echo "Error: gum not installed. Provide value as argument:" >&2
            echo "  fedpunk template update \"your value\"" >&2
            return 1
        end

        # Get current value for default
        set -l current_value (grep "^example_value=" "$config_file" 2>/dev/null | cut -d'=' -f2-)

        set new_value (gum input \
            --placeholder "Enter new value..." \
            --value "$current_value" \
            --prompt "New value: ")

        if test -z "$new_value"
            echo "Update cancelled"
            return 0
        end
    end

    # Update config file
    if test -f "$config_file"
        # Replace existing value
        sed -i "s|^example_value=.*|example_value=$new_value|" "$config_file"
    else
        # Create new config
        echo "example_value=$new_value" > "$config_file"
    end

    echo "✓ Updated config: $new_value"
end

#!/usr/bin/env fish
# ============================================================================
# Module CLI Template - Auto-Discovery Pattern
# ============================================================================
# This template demonstrates Fedpunk's auto-discovery CLI pattern.
# The pattern automatically discovers and routes subcommands with minimal code.
#
# Note: cli-dispatch is pre-loaded by fedpunk, so no manual sourcing needed!
# ============================================================================

# ============================================================================
# Main Command Function
# ============================================================================
# This function is the entry point for your module's CLI.
# The --description becomes the help text header.
#
# Pattern: cli-auto-dispatch <command-name> $argv
#   - Automatically finds all functions in this directory
#   - Generates help text from function descriptions
#   - Routes commands to the right function
# ============================================================================

function template --description "Template module commands"
    cli-auto-dispatch template $argv
end

# ============================================================================
# Subcommand Functions
# ============================================================================
# Each function becomes a subcommand. The --description appears in help.
# Implement your logic here - no boilerplate needed!
# ============================================================================

function show --description "Display the example_value parameter"
    # Optional: Handle --help for detailed subcommand help
    if contains -- "$argv[1]" --help -h
        echo "Display the example_value parameter"
        echo ""
        echo "Usage: fedpunk template show"
        echo ""
        echo "Shows the value of the example_value parameter from module params."
        return 0
    end

    # Access module parameters via FEDPUNK_PARAM_<MODULE>_<PARAM>
    # Example: module.yaml with name: template → FEDPUNK_PARAM_TEMPLATE_*
    if set -q FEDPUNK_PARAM_TEMPLATE_EXAMPLE_VALUE
        echo "Parameter value: $FEDPUNK_PARAM_TEMPLATE_EXAMPLE_VALUE"
    else
        echo "Parameter not set. Default: Hello from template module!"
    end
end

# ============================================================================
# Execution
# ============================================================================
# Call the main function with all arguments.
# WISHLIST: This could be automatic if fedpunk loads the command differently.
# ============================================================================

template $argv

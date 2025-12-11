#!/usr/bin/env fish
# Template module CLI command

function template --description "Template module commands"
    # Show help if no args or --help
    if test (count $argv) -eq 0; or contains -- "$argv[1]" --help -h
        printf "Template module commands\n"
        printf "\n"
        printf "Example CLI command provided by the template module.\n"
        printf "\n"
        printf "Usage: fedpunk template <subcommand> [options]\n"
        printf "\n"
        printf "Subcommands:\n"
        printf "  show       Display the example_value parameter\n"
        printf "\n"
        printf "Run 'fedpunk template <subcommand> --help' for more information.\n"
        return 0
    end

    # Dispatch to subcommand
    set -l subcommand $argv[1]

    if functions -q $subcommand
        $subcommand $argv[2..-1]
    else
        printf "Unknown subcommand: $subcommand\n" >&2
        printf "Run 'fedpunk template --help' for available subcommands.\n" >&2
        return 1
    end
end

function show --description "Display the example_value parameter"
    if contains -- "$argv[1]" --help -h
        printf "Display the example_value parameter\n"
        printf "\n"
        printf "Usage: fedpunk template show\n"
        printf "\n"
        printf "Shows the value of the example_value parameter from module params.\n"
        return 0
    end

    # Get the example_value parameter
    # Pattern: FEDPUNK_PARAM_<MODULE>_<PARAM>
    # Module name comes from module.yaml: name: template -> FEDPUNK_PARAM_TEMPLATE_*
    if set -q FEDPUNK_PARAM_TEMPLATE_EXAMPLE_VALUE
        printf "Parameter value: %s\n" $FEDPUNK_PARAM_TEMPLATE_EXAMPLE_VALUE
    else
        printf "Parameter not set. Default: Hello from template module!\n"
    end
end

# Execute the command
template $argv

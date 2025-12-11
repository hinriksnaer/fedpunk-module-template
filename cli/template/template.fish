#!/usr/bin/env fish
# Template module CLI command

# Source CLI dispatch library for auto-discovery
if not functions -q cli-dispatch
    source "$FEDPUNK_SYSTEM/lib/fish/cli-dispatch.fish"
end

function template --description "Template module commands"
    set -l cmd_dir (dirname (status --current-filename))
    cli-dispatch template $cmd_dir $argv
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

#!/usr/bin/env fish
# Fedpunk template CLI command
# Usage: fedpunk template <subcommand> [args]

function template-test
    # Get the example_value parameter
    # Pattern: FEDPUNK_PARAM_<MODULE>_<PARAM>
    # Module name comes from module.yaml: name: template -> FEDPUNK_PARAM_TEMPLATE_*
    if set -q FEDPUNK_PARAM_TEMPLATE_EXAMPLE_VALUE
        echo $FEDPUNK_PARAM_TEMPLATE_EXAMPLE_VALUE
    else
        echo "Parameter not set. Default: Hello from template plugin!"
    end
end

function fedpunk-template
    set -l subcommand $argv[1]

    switch "$subcommand"
        case test
            template-test $argv[2..]
        case '*'
            echo "Usage: fedpunk template <subcommand> [args]"
            echo ""
            echo "Subcommands:"
            echo "  test    Display the example_value parameter"
            return 1
    end
end

# Execute the command
fedpunk-template $argv

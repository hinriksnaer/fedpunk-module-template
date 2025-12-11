# Fedpunk Module Template

A template repository for creating external fedpunk modules with parameter support.

## Structure

```
fedpunk-module-template/
├── module.yaml           # Module definition and parameters
├── cli/
│   └── template/
│       └── template.fish # CLI commands
├── config/               # Dotfiles (stowed to $HOME)
│   └── .config/
│       └── template/
│           └── example.conf
├── scripts/              # Lifecycle scripts
│   └── example-after     # Post-deployment script
└── README.md
```

## Parameters

This module demonstrates the fedpunk parameter system:

- **example_value** (string): Example value to display
  - Default: `"Hello from template plugin!"`

## Usage

### In a Profile

Add to your profile's mode.yaml:

```yaml
modules:
  # With default parameters
  - https://github.com/hinriksnaer/fedpunk-module-template.git

  # With custom parameters
  - module: https://github.com/hinriksnaer/fedpunk-module-template.git
    params:
      example_value: "Custom greeting!"
```

### CLI Commands

```bash
# Display the example_value parameter
fedpunk template show
```

The module uses Fedpunk's auto-discovery CLI pattern, which automatically discovers and lists all available subcommands.

## Creating Your Own Module

1. Fork this template
2. Update `module.yaml` with your module name and parameters
3. Add your CLI commands in `cli/<module-name>/`
4. Add dotfiles to `config/` (will be stowed to `$HOME`)
5. Add lifecycle scripts to `scripts/` if needed
6. Access parameters via environment variables: `$FEDPUNK_PARAM_<MODULE>_<NAME>`

## Module Configuration Reference

### module.yaml Fields

```yaml
module:
  name: string              # Required: Module identifier
  description: string       # Required: Module description
  version: string          # Optional: Semantic version
  dependencies: []         # Optional: List of required modules
  priority: number         # Optional: Deployment order (lower = earlier)

parameters:                # Optional: Module parameters
  param_name:
    type: string|number|boolean
    description: string
    default: any
    required: boolean

lifecycle:
  before: []              # Scripts to run before stowing (from scripts/)
  after: []               # Scripts to run after stowing (from scripts/)

packages:
  copr: []                # COPR repositories to enable
  dnf: []                 # DNF packages to install
  cargo: []               # Cargo crates to install
  npm: []                 # NPM packages to install
  flatpak: []             # Flatpak applications to install

stow:
  target: $HOME           # Where to stow configs (default: $HOME)
  config_template: bool   # Enable template processing
  conflicts: warn         # How to handle conflicts: warn|skip|overwrite
```

### Lifecycle Scripts

Scripts in `scripts/` have access to:
- `$FEDPUNK_ROOT` - Fedpunk installation directory
- `$MODULE_NAME` - Current module name
- `$MODULE_DIR` - Module directory path
- `$HOME` - User home directory

Optional UI library for consistent output:
```fish
source "$FEDPUNK_ROOT/lib/fish/ui.fish"

ui-info "Informational message"
ui-success "Success message"
ui-error "Error message"
ui-warning "Warning message"
ui-spin --title "Loading..." -- command
```

###  CLI Auto-Discovery Pattern

Fedpunk modules can provide CLI commands using a simple auto-discovery pattern.

#### The Pattern

```fish
#!/usr/bin/env fish
# cli-dispatch is pre-loaded by fedpunk - no manual sourcing needed!

# Main command - defines the command group
function mymodule --description "My module commands"
    cli-auto-dispatch mymodule $argv
end

# Subcommands - just add functions, they're auto-discovered!
function init --description "Initialize the module"
    echo "Initializing mymodule..."
end

function status --description "Show module status"
    echo "Module status: active"
end

# Execute the command
mymodule $argv
```

#### How It Works

1. **Main function**: Uses `cli-auto-dispatch` which automatically:
   - Finds all functions in this directory (subcommands)
   - Generates help text from `--description` flags
   - Routes commands to the right function

2. **Subcommands**: Just write functions with `--description` - no boilerplate!

3. **Help is automatic**: Users get consistent help for free:
   ```bash
   $ fedpunk mymodule --help
   My module commands

   Usage: fedpunk mymodule <subcommand> [args...]

   Subcommands:
     init           Initialize the module
     status         Show module status
   ```

4. **Parameter access**: Use environment variables:
   ```fish
   if set -q FEDPUNK_PARAM_MYMODULE_CONFIG_PATH
       echo "Config: $FEDPUNK_PARAM_MYMODULE_CONFIG_PATH"
   end
   ```

#### Future Improvements

Potential future enhancements to make the pattern even simpler:
- **Auto-execute**: Automatically call the main function when the file is sourced, eliminating the need for the `mymodule $argv` line at the bottom
- **Convention-based routing**: Could potentially infer the command name from the filename to eliminate the parameter to `cli-auto-dispatch`

### Using as Profile Plugin

External modules can be used as profile-scoped plugins:

1. Clone into profile plugins directory:
   ```bash
   git clone <repo> ~/.local/share/fedpunk/profiles/<profile>/plugins/<name>
   ```

2. Reference in mode.yaml:
   ```yaml
   modules:
     - essentials
     - plugins/<name>
   ```

# Fedpunk Module Template

A template repository for creating external fedpunk modules with parameter support.

## Structure

```
fedpunk-module-template/
├── module.yaml           # Module definition and parameters
├── cli/
│   └── template/
│       └── template.fish # CLI commands (auto-discovered, zero boilerplate!)
├── config/               # Dotfiles (stowed to $HOME)
│   └── .config/
│       └── template/
│           └── config.conf # Config file with {{PLACEHOLDER}}
├── scripts/              # Lifecycle scripts
│   └── example-after     # Post-deployment script (replaces placeholders)
└── README.md
```

## How It Works

This template demonstrates the complete Fedpunk module workflow:

1. **Deploy**: `fedpunk profile deploy <profile>` (includes this module)
2. **Stow Config**: `config.conf` is symlinked to `~/.config/template/`
3. **Run Lifecycle**: `example-after` script replaces `{{PLACEHOLDER}}` with parameter value
4. **Use CLI**: `fedpunk template show` reads the config value
5. **Update**: `fedpunk template update` modifies the config (with gum UI)

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
# Display current config value
fedpunk template show

# Update config value interactively (uses gum)
fedpunk template update

# Update config value directly
fedpunk template update "New value"

# Get help
fedpunk template --help
fedpunk template show --help
```

The module uses Fedpunk's auto-discovery CLI pattern with **zero boilerplate** - just define functions!

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

#### The Minimal Pattern

```fish
#!/usr/bin/env fish
# That's it - no imports, no sourcing, cli-dispatch is pre-loaded!

# Main command - one line!
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

# No execution line needed! The fedpunk bin handles it.
```

**That's it!** Just 3 simple things:
1. Main function with one line: `cli-auto-dispatch mymodule $argv`
2. Subcommand functions with `--description`
3. No execution line, no imports, no boilerplate

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

#### Real-World Example

Check out `cli/template/template.fish` in this repo for a complete example showing:
- Config file reading and writing
- Interactive updates with gum
- Error handling and validation
- Parameter access from lifecycle scripts

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

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
fedpunk template test
```

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

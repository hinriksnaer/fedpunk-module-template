# Fedpunk Module Template

A template repository for creating external fedpunk modules with parameter support.

## Structure

```
fedpunk-module-template/
├── module.yaml           # Module definition and parameters
├── cli/
│   └── template/
│       └── template.fish # CLI commands
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
  - https://github.com/yourusername/fedpunk-module-template.git

  # With custom parameters
  - module: https://github.com/yourusername/fedpunk-module-template.git
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
4. Access parameters via environment variables: `$FEDPUNK_PARAM_<NAME>`

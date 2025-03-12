# Dotfiles

A cross-platform dotfiles management system that supports macOS, Linux, and Windows with selective installation options.

## Installation

### macOS and Linux

Use the shell script installer:

```bash
# Install everything (default)
./install.sh

# Or install specific components
./install.sh --git        # Only git configuration
./install.sh --aliases    # Only shell aliases
./install.sh --shell      # Only shell configuration

# Combine multiple options
./install.sh --git --aliases

# Show help
./install.sh --help
```

### Windows

Use the PowerShell script installer:

```powershell
# Install everything (default)
.\install.ps1

# Or install specific components
.\install.ps1 --git        # Only git configuration
.\install.ps1 --aliases    # Only PowerShell aliases
.\install.ps1 --shell      # Only PowerShell profile

# Combine multiple options
.\install.ps1 --git --aliases

# Show help
.\install.ps1 --help
```

## Components

- **Git Configuration**: Global git settings and aliases
- **Shell Aliases**: Common shell aliases for improved productivity
- **Shell Configuration**: Shell-specific settings (bash/zsh for Unix, PowerShell for Windows)

## Directory Structure

```
.
├── install.sh           # Unix installer script
├── install.ps1          # Windows installer script
├── config/             # Configuration files
│   ├── git/           # Git configuration
│   └── shell/         # Shell configuration
├── bootstrap/         # OS-specific bootstrap scripts
│   ├── install_mac.sh
│   └── install_linux.sh
└── platform/          # Platform-specific configurations
```

## Notes

- The Unix installer (`install.sh`) supports macOS and Linux
- The Windows installer (`install.ps1`) provides equivalent functionality using PowerShell
- Each component can be installed independently or together
- OS-specific bootstrapping is only performed when installing all components

## Features

- **Cross-platform compatibility**: Works on macOS, Linux, and Windows
- **Modular design**: Easy to add or remove components
- **Shared configurations**: Common settings work across platforms
- **Platform-specific optimizations**: Each OS gets its own tailored settings

## Customization

Edit files in the `config/` directory for shared settings, or in the appropriate platform directory for OS-specific configurations.

## License

MIT 
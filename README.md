# Cross-Platform Dotfiles

A portable dotfiles repository that works across macOS, Linux, and Windows while maintaining consistency and shared configurations where possible.

## Repository Structure

```
dotfiles/
│── bootstrap/        # Bootstrapping scripts (per OS)
│   ├── install_mac.sh
│   ├── install_linux.sh
│   ├── install_windows.ps1
│── config/           # Config files (platform-agnostic)
│   ├── aliases       # Aliases (portable)
│   ├── gitconfig     # Global Git config
│   ├── shellrc       # Common shell settings
│── platform/         # OS-specific configurations
│   ├── macos/
│   │   ├── zshrc
│   │   ├── brewfile
│   ├── linux/
│   │   ├── bashrc
│   │   ├── apt_packages
│   ├── windows/
│   │   ├── powershell_profile.ps1
│── scripts/          # Utility scripts (helper functions)
│── install.sh        # Main installer (detects OS)
```

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   ```

2. Run the installer:
   ```bash
   cd ~/.dotfiles
   ./install.sh
   ```

The installer will detect your operating system and set up the appropriate configurations.

## Features

- **Cross-platform compatibility**: Works on macOS, Linux, and Windows
- **Modular design**: Easy to add or remove components
- **Shared configurations**: Common settings work across platforms
- **Platform-specific optimizations**: Each OS gets its own tailored settings

## Customization

Edit files in the `config/` directory for shared settings, or in the appropriate platform directory for OS-specific configurations.

## License

MIT 
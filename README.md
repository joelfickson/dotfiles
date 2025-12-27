# dotfiles

Personal configuration files for various shells and tools.

## Structure

```
dotfiles/
├── fish/           # Fish shell configuration
│   └── config.fish
├── ghostty/        # Ghostty terminal configuration
│   └── config
└── zsh/            # Zsh shell configuration
    ├── .zshrc      # Main zsh configuration
    └── .zshenv     # Environment variables loaded before .zshrc
```

## Prerequisites

### Common Tools
- [Homebrew](https://brew.sh/) - Package manager for macOS
- [Git](https://git-scm.com/) - Version control

### Zsh Requirements
- [Oh My Zsh](https://ohmyz.sh/) - Zsh configuration framework
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme
- [Starship](https://starship.rs/) - Cross-shell prompt
- [Zinit](https://github.com/zdharma-continuum/zinit) - Zsh plugin manager (auto-installs on first run)

### Zsh Plugins (installed via Oh My Zsh)
- `git` - Git aliases and functions
- `docker-compose` - Docker Compose completions
- `pnpm` - pnpm completions
- `history` - History shortcuts
- `zsh-syntax-highlighting` - Syntax highlighting
- `zsh-autosuggestions` - Fish-like autosuggestions
- `nvm` - Node Version Manager support

Install the custom plugins:
```bash
# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

### Development Tools (included in config)
- [NVM](https://github.com/nvm-sh/nvm) - Node Version Manager
- [Bun](https://bun.sh/) - JavaScript runtime
- [pnpm](https://pnpm.io/) - Fast, disk space efficient package manager
- [Rust/Cargo](https://www.rust-lang.org/) - Rust toolchain
- [Flutter](https://flutter.dev/) - Mobile development framework
- [PostgreSQL](https://www.postgresql.org/) - Database

## Installation

### Zsh Shell

1. **Install Oh My Zsh:**
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

2. **Install Powerlevel10k:**
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

3. **Install Starship:**
```bash
brew install starship
```

4. **Install custom plugins** (see Zsh Plugins section above)

5. **Install configuration files:**
```bash
# Backup existing configs
mv ~/.zshrc ~/.zshrc.backup
mv ~/.zshenv ~/.zshenv.backup

# Symlink the config files
ln -sf $(pwd)/zsh/.zshrc ~/.zshrc
ln -sf $(pwd)/zsh/.zshenv ~/.zshenv

# Or copy the files
cp zsh/.zshrc ~/.zshrc
cp zsh/.zshenv ~/.zshenv
```

6. **Run Powerlevel10k configuration** (if needed):
```bash
p10k configure
```

### Ghostty Terminal

To install the Ghostty terminal configuration:

```bash
# Create ghostty config directory if it doesn't exist
mkdir -p ~/.config/ghostty

# Symlink the config file
ln -sf $(pwd)/ghostty/config ~/.config/ghostty/config

# Or copy the file
cp ghostty/config ~/.config/ghostty/config
```

**For icons to display properly in Tide:**
```bash
# Install a Nerd Font (required for icons)
brew install --cask font-meslo-lg-nerd-font

# Or install other Nerd Fonts:
# brew install --cask font-hack-nerd-font
# brew install --cask font-fira-code-nerd-font
```

After installing, restart Ghostty for changes to take effect.

### Fish Shell

To install the fish configuration:

```bash
# Install fish shell
brew install fish

# Create fish config directory if it doesn't exist
mkdir -p ~/.config/fish

# Symlink the config file
ln -sf $(pwd)/fish/config.fish ~/.config/fish/config.fish

# Or copy the file
cp fish/config.fish ~/.config/fish/config.fish
```

## Included Features

### PATH Additions
The configuration adds the following to your PATH:
- Homebrew binaries (`/opt/homebrew/opt/*/bin`)
- pnpm global binaries
- Flutter SDK
- PostgreSQL 16 & 17
- Codeium Windsurf
- Antigravity CLI
- OpenCode
- Bun runtime
- Sekuire CLI
- NVM (Node Version Manager)
- Cargo (Rust)
- Custom `.local/bin`

### Aliases
- `pip` → `pip3` - Use Python 3's pip by default
- `cc` → `claude` - Claude CLI shortcut
- `ccg` → `claude-glm` - Claude GLM shortcut
- `ccg45` → `claude-glm-4.5` - Claude GLM 4.5 shortcut
- `ccf` → `claude-glm-fast` - Claude GLM fast shortcut

### Custom Functions
- `kimi_claude()` - Run Claude CLI with Kimi API endpoint
- `deepseek()` - Run Claude CLI with DeepSeek API endpoint

### Docker Completions
Docker completions are automatically loaded from `~/.docker/completions`

## Usage

After installation:

1. **Zsh Shell**: Restart your terminal or run:
   ```bash
   source ~/.zshenv
   source ~/.zshrc
   ```

2. **Fish Shell**: Restart your terminal or run:
   ```bash
   source ~/.config/fish/config.fish
   ```

## Migrating from Zsh to Fish

Fish shell has a different syntax than Zsh. Here are the key differences:

- **Environment Variables**: Use `set -gx VAR value` instead of `export VAR=value`
- **PATH**: Use `fish_add_path /path/to/bin` instead of `export PATH="/path/to/bin:$PATH"`
- **Aliases**: Use `alias name='command'` (same as Zsh)
- **Functions**: Fish has a different function syntax - see [Fish documentation](https://fishshell.com/docs/current/index.html)

For fish equivalents of common tools:
- [Fisher](https://github.com/jorgebucaran/fisher) - Plugin manager for fish (like Oh My Zsh)
- [Tide](https://github.com/IlanCosman/tide) - Modern prompt for fish (like Powerlevel10k)
- [z for fish](https://github.com/jethrokuan/z) - Directory jumping

## Customization

Feel free to modify the configuration files to suit your needs. Add aliases, functions, and environment variables as needed.

## Security Note

⚠️ **Important**: Never commit sensitive information like API keys or tokens to version control. 

The `.zshrc` includes custom functions with API keys redacted (marked as `sk-`). Before using:
1. Create a separate file for secrets (e.g., `~/.secrets.zsh`)
2. Add your real API keys there
3. Source it in your `.zshrc`: `source ~/.secrets.zsh`
4. Add `*.secrets.*` to `.gitignore`

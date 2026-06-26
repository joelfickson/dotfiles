# dotfiles

Personal configuration files for macOS (fish shell, Ghostty, Zed) plus a versioned library of Claude Code skills.

## Structure

```
dotfiles/
├── fish/                 # Fish shell configuration (full directory)
│   ├── config.fish        # Main config
│   ├── fish_plugins       # Fisher plugin list
│   ├── fish_variables     # Universal vars (prompt colors, Tide settings)
│   ├── functions/         # Fish functions (includes Fisher + plugins)
│   ├── completions/       # Completions
│   └── conf.d/            # Auto-sourced configs
├── ghostty/              # Ghostty terminal configuration
│   └── config
├── skills/               # Claude Code skills (one folder per skill, each with SKILL.md)
│   ├── writing/          # Prose: technical docs, blog, general voice
│   ├── design-principles/# House design rules (no border framing)
│   └── .../              # Imported personal skill library
└── zsh/                  # Zsh configuration
    ├── .zshrc
    └── .zshenv
```

## Prerequisites

Common:
- [Homebrew](https://brew.sh/)
- [Git](https://git-scm.com/)

Fish/Ghostty:
- [Fish](https://fishshell.com/) (config expects Homebrew fish at `/opt/homebrew/bin/fish`)
- [Ghostty](https://ghostty.org/)
- Nerd Font (required for Tide icons)  
  `brew install --cask font-meslo-lg-nerd-font`

Zsh (optional):
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Starship](https://starship.rs/)

## Installation

### 1) Clone this repo

```bash
git clone <your-repo-url> ~/code/dotfiles
cd ~/code/dotfiles
```

### 2) Ghostty

```bash
mkdir -p ~/.config/ghostty
ln -sfn "$(pwd)/ghostty/config" ~/.config/ghostty/config
```

Notes:
- Ghostty config sets `command = /opt/homebrew/bin/fish`. If fish is installed elsewhere, update `ghostty/config`.
- `font-family = "MesloLGS NF"` assumes the Nerd Font is installed.

### 3) Fish (recommended)

Install fish and set it as your default shell:

```bash
brew install fish
chsh -s /opt/homebrew/bin/fish
```

Link the full fish directory (recommended so plugins and completions are included):

```bash
mkdir -p ~/.config
mv ~/.config/fish ~/.config/fish.backup
ln -sfn "$(pwd)/fish" ~/.config/fish
```

If you prefer copying instead of symlinking:

```bash
mkdir -p ~/.config/fish
rsync -a fish/ ~/.config/fish/
```

Sync fish plugins (uses `fish/fish_plugins`):

```bash
fish -lc 'fisher update'
```

Important:
- `fish_variables` is machine-specific and includes Tide prompt settings and colors. If you already have a setup you want to keep, remove or replace `~/.config/fish/fish_variables` before launching fish.
- Secrets are loaded from `~/.config/fish/secrets.fish`. Create that file for API keys or tokens.

### 4) Zsh (optional)

Install Oh My Zsh and Powerlevel10k:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
brew install starship
```

Install custom plugins:

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

Link the Zsh configs:

```bash
mv ~/.zshrc ~/.zshrc.backup
mv ~/.zshenv ~/.zshenv.backup
ln -sfn "$(pwd)/zsh/.zshrc" ~/.zshrc
ln -sfn "$(pwd)/zsh/.zshenv" ~/.zshenv
```

## Included Features

### Fish plugins (via Fisher)
- `jorgebucaran/fisher`
- `jorgebucaran/nvm.fish`
- `ilancosman/tide`
- `franciscolourenco/done`
- `jorgebucaran/replay.fish`
- `jhillyerd/plugin-git`
- `zuisong/pnpm-fish-completion`

### PATH additions in fish
The fish config adds paths for:
- Homebrew tools (`/opt/homebrew/opt/*/bin`)
- pnpm
- Flutter
- PostgreSQL 16 and 17
- Bun
- Cargo (Rust)
- JetBrains Toolbox scripts
- Custom `~/.local/bin` and other user tools

### Aliases
- `pip` -> `pip3`
- `cc` -> `claude`
- `ccg` -> `claude-glm`
- `ccg45` -> `claude-glm-4.5`
- `ccf` -> `claude-glm-fast`

### Custom functions
- `kimi_claude` and `deepseek` wrappers for Claude CLI with alternate endpoints

### Prompt
- Uses Starship if installed
- Tide prompt is installed and configured via `fish_variables`

## Claude Code skills

`skills/` holds Claude Code skills, one folder per skill, each with a `SKILL.md`. They live here so they travel with the dotfiles and stay version-controlled.

- `writing/` - prose skill for technical docs, blog posts, and general team messages, with the house style (no emojis or em-dashes), plain words, and conciseness rules.
- `design-principles/` - house design rules layered on top of the task-specific design skills. First rule: no border framing (use whitespace, background, and shadow instead).
- The rest is a personal skill library (marketing, design, and dev-workflow skills) imported from `~/.claude/skills`.

`install.sh` does not link these yet. To use one in Claude Code, symlink the individual skill into your skills directory (do not replace the whole `~/.claude/skills` folder):

```bash
ln -sfn "$(pwd)/skills/writing" ~/.claude/skills/writing
```

## Post-install checklist

1. Restart Ghostty (or any terminal) after linking configs.
2. Start a new fish session: `exec fish`
3. Run `fisher update` if you want to resync plugins.

## Security note

Do not commit secrets. Store tokens in a separate file:
- Fish: `~/.config/fish/secrets.fish`
- Zsh: `~/.secrets.zsh` (source it from `.zshrc` if needed)

## Customization

Modify the config files to suit your needs. If you change prompt settings, update `fish_variables` or re-run `tide configure`.

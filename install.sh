#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Dotfiles Installation ==="
echo "Installing from: $DOTFILES_DIR"
echo ""

# --- Homebrew ---
echo "[1/6] Checking Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed"
fi

# --- Brewfile ---
echo ""
echo "[2/6] Installing Homebrew packages..."
if [[ -f "$DOTFILES_DIR/Brewfile" ]]; then
    brew bundle install --file="$DOTFILES_DIR/Brewfile"
else
    echo "Warning: Brewfile not found, skipping"
fi

# --- Ghostty ---
echo ""
echo "[3/6] Setting up Ghostty..."
mkdir -p ~/.config/ghostty
if [[ -L ~/.config/ghostty/config ]]; then
    echo "Ghostty config already symlinked"
elif [[ -f ~/.config/ghostty/config ]]; then
    echo "Backing up existing Ghostty config..."
    mv ~/.config/ghostty/config ~/.config/ghostty/config.backup
    ln -sfn "$DOTFILES_DIR/ghostty/config" ~/.config/ghostty/config
    echo "Ghostty config linked"
else
    ln -sfn "$DOTFILES_DIR/ghostty/config" ~/.config/ghostty/config
    echo "Ghostty config linked"
fi

# --- Fish ---
echo ""
echo "[4/6] Setting up Fish..."
mkdir -p ~/.config

if [[ -L ~/.config/fish ]]; then
    echo "Fish config already symlinked"
elif [[ -d ~/.config/fish ]]; then
    echo "Backing up existing Fish config..."
    mv ~/.config/fish ~/.config/fish.backup
    ln -sfn "$DOTFILES_DIR/fish" ~/.config/fish
    echo "Fish config linked"
else
    ln -sfn "$DOTFILES_DIR/fish" ~/.config/fish
    echo "Fish config linked"
fi

# Set fish as default shell
FISH_PATH="/opt/homebrew/bin/fish"
if [[ -x "$FISH_PATH" ]]; then
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "Adding fish to /etc/shells (requires sudo)..."
        echo "$FISH_PATH" | sudo tee -a /etc/shells > /dev/null
    fi

    if [[ "$SHELL" != "$FISH_PATH" ]]; then
        echo "Setting fish as default shell..."
        chsh -s "$FISH_PATH"
    else
        echo "Fish is already the default shell"
    fi
else
    echo "Warning: Fish not found at $FISH_PATH"
fi

# --- Fisher plugins ---
echo ""
echo "[5/6] Installing Fisher plugins..."
if [[ -x "$FISH_PATH" ]]; then
    $FISH_PATH -c 'fisher update' 2>/dev/null || echo "Run 'fisher update' manually after first fish launch"
else
    echo "Skipping Fisher - fish not installed"
fi

# --- Zed ---
echo ""
echo "[6/6] Setting up Zed..."
mkdir -p ~/.config/zed
if [[ -d "$DOTFILES_DIR/zed" ]]; then
    for file in "$DOTFILES_DIR/zed"/*; do
        filename=$(basename "$file")
        target="$HOME/.config/zed/$filename"
        if [[ -L "$target" ]]; then
            echo "Zed $filename already symlinked"
        elif [[ -f "$target" ]]; then
            echo "Backing up existing Zed $filename..."
            mv "$target" "$target.backup"
            ln -sfn "$file" "$target"
            echo "Zed $filename linked"
        else
            ln -sfn "$file" "$target"
            echo "Zed $filename linked"
        fi
    done
else
    echo "No Zed config found, skipping"
fi

# --- Secrets reminder ---
echo ""
echo "=== Installation Complete ==="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal (or run: exec fish)"
echo "  2. Create secrets file: ~/.config/fish/secrets.fish"
echo "  3. Run 'fisher update' if plugins didn't install"
echo "  4. Run 'tide configure' to set up your prompt"
echo ""

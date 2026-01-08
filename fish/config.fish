if status is-interactive
    # Commands to run in interactive sessions can go here
    
    # ============================================
    # PATH Configuration
    # ============================================
    
    # pnpm
    set -gx PNPM_HOME "$HOME/Library/pnpm"
    fish_add_path $PNPM_HOME

    # Homebrew tools
    fish_add_path /opt/homebrew/opt/jpeg/bin
    fish_add_path /opt/homebrew/opt/postgresql@16/bin
    fish_add_path /opt/homebrew/opt/postgresql@17/bin
    fish_add_path /opt/homebrew/opt/libpq/bin
    fish_add_path /opt/homebrew/opt/make/libexec/gnubin
    if type -q /opt/homebrew/bin/brew
        /opt/homebrew/bin/brew shellenv | source
    end

    # Python 3.13 framework
    fish_add_path /Library/Frameworks/Python.framework/Versions/3.13/bin
    
    # Flutter
    fish_add_path /opt/homebrew/Caskroom/flutter/3.16.5/flutter/bin
    
    # Development tools
    fish_add_path $HOME/.codeium/windsurf/bin
    fish_add_path $HOME/.antigravity/antigravity/bin
    fish_add_path $HOME/.opencode/bin
    fish_add_path $HOME/.sekuire/bin
    fish_add_path $HOME/.local/bin
    fish_add_path "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
    
    # Bun
    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path $BUN_INSTALL/bin
    
    
    # NVM (Node Version Manager) for Fish
    # Install nvm.fish first: fisher install jorgebucaran/nvm.fish
    # Then you can use: nvm install latest, nvm use latest, etc.
    
    # ============================================
    # Aliases
    # ============================================
    
    alias pip='pip3'
    alias cc='claude'
    alias ccg='claude-glm'
    alias ccg45='claude-glm-4.5'
    alias ccf='claude-glm-fast'
    
    # ============================================
    # Custom Functions
    # ============================================
    
    # Kimi Claude wrapper
    function kimi_claude
        begin
            set -lx ANTHROPIC_BASE_URL https://api.moonshot.cn/v1
            set -lx ANTHROPIC_AUTH_TOKEN sk-  # Add your token here or in secrets.fish
            set -lx ANTHROPIC_MODEL kimi-k2-thinkinig
            set -lx ANTHROPIC_SMALL_FAST_MODEL kimi-k2-thinkinig-fast
            claude $argv
        end
    end
    
    # DeepSeek wrapper
    function deepseek
        begin
            set -lx ANTHROPIC_BASE_URL https://api.deepseek.com/v1
            set -lx ANTHROPIC_AUTH_TOKEN sk-  # Add your token here or in secrets.fish
            set -lx ANTHROPIC_MODEL deepseek-reasoner
            set -lx ANTHROPIC_SMALL_FAST_MODEL deepseek-reasoner
            claude $argv
        end
    end
    
    # ============================================
    # Prompt Configuration
    # ============================================
    
    # Starship prompt (install with: brew install starship)
    if type -q starship
        starship init fish | source
    end
    
    # Alternative: Use Tide prompt (install with: fisher install IlanCosman/tide)
    # Tide is a native fish prompt similar to Powerlevel10k
    
    # ============================================
    # Secrets (API keys, tokens, etc.)
    # ============================================
    
    # Load secrets from a separate file (not tracked in git)
    if test -f $HOME/.config/fish/secrets.fish
        source $HOME/.config/fish/secrets.fish
    end
    
    # ============================================
    # Docker Completions
    # ============================================
    
    if test -d $HOME/.docker/completions
        # Fish will automatically load completions from this directory
        set -gx fish_complete_path $HOME/.docker/completions $fish_complete_path
    end
end

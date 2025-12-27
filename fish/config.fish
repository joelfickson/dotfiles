if status is-interactive
   
    set -gx PNPM_HOME "$HOME/Library/pnpm"
    fish_add_path $PNPM_HOME
    fundle plugin zuisong/pnpm-fish-completion

    # Homebrew tools
    fish_add_path /opt/homebrew/opt/jpeg/bin
    fish_add_path /opt/homebrew/opt/postgresql@16/bin
    fish_add_path /opt/homebrew/opt/postgresql@17/bin
    fish_add_path /opt/homebrew/opt/libpq/bin
    fish_add_path /opt/homebrew/opt/make/libexec/gnubin
    
    # Flutter
    fish_add_path /opt/homebrew/Caskroom/flutter/3.16.5/flutter/bin
    
    # Development tools
    fish_add_path $HOME/.codeium/windsurf/bin
    fish_add_path $HOME/.antigravity/antigravity/bin
    fish_add_path $HOME/.opencode/bin
    fish_add_path $HOME/.sekuire/bin
    fish_add_path $HOME/.local/bin
    

    set -gx BUN_INSTALL "$HOME/.bun"
    fish_add_path $BUN_INSTALL/bin
    
    fish_add_path $HOME/.cargo/bin

    
    alias pip='pip3'
    alias cc='claude'
    alias ccg='claude-glm'
    alias ccg45='claude-glm-4.5'
    alias ccf='claude-glm-fast'
    

    

    function kimi_claude
        begin
            set -lx ANTHROPIC_BASE_URL https://api.moonshot.cn/v1
            set -lx ANTHROPIC_AUTH_TOKEN sk-  # Add your token here or in secrets.fish
            set -lx ANTHROPIC_MODEL kimi-k2-thinkinig
            set -lx ANTHROPIC_SMALL_FAST_MODEL kimi-k2-thinkinig-fast
            claude $argv
        end
    end
    

    function deepseek
        begin
            set -lx ANTHROPIC_BASE_URL https://api.deepseek.com/v1
            set -lx ANTHROPIC_AUTH_TOKEN sk-  # Add your token here or in secrets.fish
            set -lx ANTHROPIC_MODEL deepseek-reasoner
            set -lx ANTHROPIC_SMALL_FAST_MODEL deepseek-reasoner
            claude $argv
        end
    end
    
    if type -q starship
        starship init fish | source
    end
    
    if test -f $HOME/.config/fish/secrets.fish
        source $HOME/.config/fish/secrets.fish
    end
    

    
    if test -d $HOME/.docker/completions
        set -gx fish_complete_path $HOME/.docker/completions $fish_complete_path
    end
end

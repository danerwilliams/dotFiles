#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Initialize and update submodules
git -C "$DOTFILES_DIR" submodule update --init --recursive

# Vim
ln -sfn "$DOTFILES_DIR/dotVim" "$HOME/.vim"
ln -sf "$DOTFILES_DIR/dotVim/vimrc" "$HOME/.vimrc"

# Tmux
ln -sfn "$DOTFILES_DIR/dotTmux" "$HOME/.tmux"
ln -sf "$DOTFILES_DIR/dotTmux/tmux.conf" "$HOME/.tmux.conf"

# Bash
ln -sfn "$DOTFILES_DIR/dotBash" "$HOME/.bash"
ln -sf "$DOTFILES_DIR/dotBash/bash_profile" "$HOME/.bash_profile"
# Source bashrc rather than symlinking it, since Ona overwrites .bashrc
# after the install script runs to inject its secrets block
if ! grep -q "dotBash/bashrc" "$HOME/.bashrc" 2>/dev/null; then
    echo '[ -r ~/dotfiles/dotBash/bashrc ] && source ~/dotfiles/dotBash/bashrc' >> "$HOME/.bashrc"
fi

# Install Vim plugins non-interactively
# First run hits "Press ENTER" from missing colorscheme; yes '' feeds newlines to dismiss prompts
if command -v vim &> /dev/null; then
    yes '' | vim +PluginInstall +qall 2>/dev/null || true
fi

# Claude Code - enable vim mode
mkdir -p "$HOME/.claude"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"
if [ -f "$CLAUDE_SETTINGS" ]; then
    # Update existing settings with vim mode
    tmp=$(mktemp)
    jq '. + {"editorBindings": "vim"}' "$CLAUDE_SETTINGS" > "$tmp" && mv "$tmp" "$CLAUDE_SETTINGS"
else
    # Create new settings file with vim mode
    echo '{"editorBindings": "vim"}' > "$CLAUDE_SETTINGS"
fi

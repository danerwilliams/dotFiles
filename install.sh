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
ln -sf "$DOTFILES_DIR/dotBash/bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES_DIR/dotBash/bash_profile" "$HOME/.bash_profile"

# Install Vim plugins
if command -v vim &> /dev/null; then
    vim +PluginInstall +qall 2>/dev/null
fi

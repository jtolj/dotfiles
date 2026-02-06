#!/bin/bash
set -e

echo "Stowing mailmate configuration"
mkdir -p "$HOME/Library/Application Support/MailMate/Resources/KeyBindings" && stow --restow -v -t "$HOME/Library/Application Support/MailMate/Resources/KeyBindings" "mailmate"

# Files that live in $XDG_CONFIG_HOME
xdg_config_files=(
	"aerospace"
	"asciinema"
	"atuin"
	"hl"
	"infat"
	"kanata"
	"karabiner"
	"mise"
	"nvim"
	"oh-my-posh"
	"sketchybar"
	"wezterm"
)

for pkg in "${xdg_config_files[@]}"; do
	echo "Stowing $pkg in $HOME/.config/$pkg"
	mkdir -p "$HOME/.config/$pkg" && stow --restow -v -t "$HOME/.config/$pkg" "$pkg"
done

# Files that live in home directory
home_dir_files=(
	"git"
	"hammerspoon"
	"homebrew"
	"zsh"
)

for pkg in "${home_dir_files[@]}"; do
	echo "Stowing $pkg contents in home directory"
	stow --dotfiles --restow -v -t ~ "$pkg"
done

# scripts for ~/.local/bin
echo "Stowing scripts in ~/.local/bin"
mkdir -p "$HOME/.local/bin" && stow --restow -v -t "$HOME/.local/bin/" "local-bin"

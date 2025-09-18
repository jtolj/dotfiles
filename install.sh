#!/bin/bash
set -e

# Files that live in $XDG_CONFIG_HOME
xdg_config_files=("aerospace" "asciinema" "atuin" "gh-dash"	"infat"	"mise" "nvim"	"oh-my-posh" "sketchybar" "svim" "wezterm")

for pkg in "${xdg_config_files[@]}"; do
	echo "Stowing $pkg in $HOME/.config/$pkg"
	mkdir -p "$HOME/.config/$pkg" && stow --restow -v -t "$HOME/.config/$pkg" "$pkg"
done

# Files that live in home directory
home_dir_files=("hammerspoon" "git" "homebrew" "zsh")
for pkg in "${home_dir_files[@]}"; do
	echo "Stowing $pkg contents in home directory"
	stow --dotfiles --restow -v -t ~ "$pkg"
done

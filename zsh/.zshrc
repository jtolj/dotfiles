
###################
#   trace start   #
###################
# PS4=$'%D{%s%6.}-_-'
# exec 3>&2 2>/tmp/sample-time.$$.log
# zmodload zsh/zprof
# setopt xtrace prompt_subst
HOME=${HOME:-'/Users/jesse'}

path=(
  /opt/homebrew/opt/grep/libexec/gnubin
  /usr/local/sbin
  /usr/local/bin
  $HOME/.composer/vendor/bin
  $HOME/Library/Android/sdk/platform-tools/
  /opt/homebrew/opt/mysql-client/bin
  $path
)

export VI_MODE_SET_CURSOR=true
export QUOTING_STYLE=literal

# Disable freeze
stty -ixon

if [ -f /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

[[ -r ~/.zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        git@github.com:marlonrichert/zsh-snap.git ~/.zsh-snap
zstyle ':znap:*' repos-dir ~/.znap
zstyle ':znap:*' server git@github.com
source ~/.zsh-snap/znap.zsh
znap eval zoxide 'zoxide init --cmd z zsh'
export ARTISAN_PREFIX=valet
export ARTISAN_OPEN_ON_MAKE_EDITOR=nvim
znap source jtolj/zsh-artisan
znap source zsh-users/zsh-syntax-highlighting
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
znap source ohmyzsh/ohmyzsh plugins/magic-enter 
znap source ohmyzsh/ohmyzsh plugins/vi-mode
znap source reegnz/jq-zsh-plugin
znap source Aloxaf/fzf-tab
znap source zdharma/fast-syntax-highlighting
znap eval atuin 'atuin init zsh'
znap eval starship 'starship init zsh'
znap eval mise 'mise activate'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'


# Set up GPG
export GPG_TTY=$(tty)

### Helpers and aliases ###
alias vim="nvim"
alias n="nvim"
alias date="gdate"
alias lls="ls"
alias vs="code"
alias p="[ -d ~/Projects ] && cd ~/Projects"
alias a="artisan"
alias tinker="artisan tinker"
alias which="/usr/bin/which"
alias ..="cd .."
alias ...="cd ../.."
alias tmp="cd $TMPDIR"

function ls() {
  eza --icons "$@"
}

# Notify after command finishes
function lmk() {
  OUTPUT=$("$@")
  if [ $? -eq 0 ]; then
    STATUS="✅ Command Succeeded"
  else
    STATUS="🔴 Command Failed"
  fi
  terminal-notifier -message "$OUTPUT" \
    -title "$STATUS" \
    -subtitle "$@" \
    -timeout 5
}

## Open a directory / project in Tinkerwell
function tw {
  if [ $# -eq 0 ] || [ $1 = "." ]; then
    TW_PATH=$(pwd)
  else
    TW_PATH=$1
  fi

  TW_PATH=$(echo -n $TW_PATH | base64)

  open "tinkerwell://?cwd=$TW_PATH"
}

# Wezterm
alias icat="wezterm imgcat"
alias wssh="wezterm ssh"

# Flush local DNS cache
flushdns() {
  sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
}

#PHP Stuff
alias php="valet php"
alias composer="valet composer"

# "with xdebug" function, run the command with xdebug enabled
phpx () {
  if [ -z "$1" ]; then
    echo "Usage: phpx <command>"
    return
  fi

  XDEBUG_TRIGGER=1 valet php "$@"
}

# "with xdebug" function, run the artisan command with xdebug enabled
ax () {
 if [ -z "$1" ]; then
    echo "Usage: ax <command>"
    return
  fi

  XDEBUG_TRIGGER=1 valet php artisan "$@"
}

# Git stuff
alias gcb="git checkout -b"
alias gap="git add -p"
alias gcm="git commit -m"
alias gco="git checkout"
alias gcod="git checkout develop"
alias gcom="git checkout master"
alias grhh="git reset --hard HEAD"

# History search with wildcards - ex ghs "*filename.ext"
alias ghs="git log --all --full-history --"

gfo() {
  git fetch origin $1:$1
}

# Resets the timestamp for the most recent commit to the current time
gtnow() {
  git commit --amend --date "$(date -R)"
}

treediff() {
  git log --left-right --graph --cherry-pick --oneline
}

# Clean up already merged branches with list of branch names
cleanbranches() {
  git branch --merged| grep -E -v "(^\*|master|develop|staging|main|dev)" | xargs git branch -d
}


# Delete branches that have been removed from the remote
nukebranches() {
  git fetch --prune
  # Use an array to store branches rather than piping through a loop
  local branches=($(git branch -vv | grep 'gone]' | awk '{print $1}'))
  
  
  for branch in "${branches[@]}"; do
    # Skip empty branches
    if [ -z "$branch" ]; then
      continue
    fi
    
    # Skip protected branches
    if [[ "$branch" == "main" || "$branch" == "master" || "$branch" == "develop" || "$branch" == "staging" ]]; then
      continue
    fi

    echo -n "Would you like to delete $branch? (y/n) "
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      git branch -D "$branch"
      echo "Deleted branch: $branch"
    else
      echo "Skipped branch: $branch"
    fi
  done
}

# Aliases less / more to either fx, bat or icat
maybeitsjsonorsomething() {
  if [[ $1 == *.json ]]; then
    fx "${@}" || bat "${@}"
  elif [[ $1 == *.jpg || $1 == *.png || $1 == *.gif ]]; then
    icat "${@}"
  elif [[ $1 == *.pdf ]]; then
    fancy-cat "${@}"
  else
    bat "${@}"
  fi
}

alias -g more="maybeitsjsonorsomething"
alias -g less="maybeitsjsonorsomething"

## Kill all processes matching a grep pattern
killgrep() {
  echo "Killing:\n"
  ps aux | grep "$@"

  read -q "REPLY?Are you sure? "
  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    ps aux | grep "$@" | awk '{print $2}' | xargs kill -9
  fi
}

## Bitwarden get password and print to stdout
pw() {
  bw get password "$@"
}

## Bitwarden get password and copy to clipboard
pwcopy() {
  bw get password "$@" | pbcopy
}

# open a lando database
ldb() {
  open $(lando info --format=json -s database 2>/dev/null | jq -r '.[0] | "mysql://\(.creds.user):\(.creds.password)@\(.external_connection.host):\(.external_connection.port)/\(.creds.database)"')
}

# atuin helpers
atuin_prune_failed() {
  atuin search --delete -e 1 ""
}

if [ -f "$HOME/.zshrc_local" ]; then
  source "$HOME/.zshrc_local"
fi

#################
#   trace end   #
#################
# unsetopt xtrace
# zprof >! /tmp/zprof
# local line last
# while IFS= read -r line; do
#   if [[ ${line} =~ '^[0-9]+-_-' ]]; then
#     if [[ -n ${last} ]]; then
#       printf "%.6f %s\n" $(( (${line%%-_-*} - ${last%%-_-*}) / (10.0 ** 6) )) ${last#*-_-}
#     fi
#     last=${line}
#   fi
# done < /tmp/sample-time.(*).log > /tmp/ztrace.log


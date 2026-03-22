# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Essential environment variables
export EDITOR='vim'
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=0

# Consolidated PATH setup (before plugin/prompt init so tools are discoverable)
export PATH="$HOME/bin:/usr/local/bin:$HOME/.deno/bin:$HOME/.local/bin:./bin:./scripts:$PATH"

# PostgreSQL path (if available)
[[ -d /usr/lib/postgresql/14/bin ]] && export PATH="/usr/lib/postgresql/14/bin:$PATH"

# macOS specific paths
if [[ $OSTYPE == 'darwin'* ]]; then
  export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
fi

# SSH agent configuration (consumed by OMZ ssh-agent plugin via antidote)
zstyle :omz:plugins:ssh-agent agent-forwarding on

# Antidote plugin manager (brew on macOS, git clone on Linux)
if [[ -f "$(brew --prefix 2>/dev/null)/opt/antidote/share/antidote/antidote.zsh" ]]; then
  source "$(brew --prefix)/opt/antidote/share/antidote/antidote.zsh"
elif [[ -f "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.antidote/antidote.zsh"
fi
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# Starship prompt
eval "$(starship init zsh)"

# Lazy-load development tools - these will only initialize when first used
lazy_load_cargo() {
  unfunction lazy_load_cargo cargo 2>/dev/null
  [[ -s "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
  export PATH="$HOME/.cargo/bin:$PATH"
  if [[ $# -gt 0 ]]; then
    command "$@"
  fi
}

lazy_load_ghcup() {
  unfunction lazy_load_ghcup ghcup 2>/dev/null
  [[ -f "$HOME/.ghcup/env" ]] && source "$HOME/.ghcup/env"
  if [[ $# -gt 0 ]]; then
    command "$@"
  fi
}

lazy_load_direnv() {
  unfunction lazy_load_direnv
  if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
  fi
}

lazy_load_gcloud() {
  unfunction lazy_load_gcloud gcloud gsutil 2>/dev/null
  if [[ $OSTYPE == 'darwin'* && -f "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc" ]]; then
    source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
  fi
  if [[ $# -gt 0 ]]; then
    command "$@"
  fi
}

# Create wrapper functions for lazy loading
cargo() { lazy_load_cargo cargo "$@"; }
ghcup() { lazy_load_ghcup ghcup "$@"; }
gcloud() { lazy_load_gcloud gcloud "$@"; }
gsutil() { lazy_load_gcloud gsutil "$@"; }

# Auto-load direnv on directory change
autoload -U add-zsh-hook
add-zsh-hook chpwd lazy_load_direnv

# Fast Node.js manager (defensive — skips if not installed)
command -v fnm &>/dev/null && eval "$(fnm env --use-on-cd --shell zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Additional PATH entries
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
[[ -d $HOME/go/bin ]] && export PATH="$HOME/go/bin:$PATH"

# LM Studio (if installed)
[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

# ZSH extensions
autoload zmv

# Load aliases if available
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Load Nix profile if available
[[ -e ~/.nix-profile/etc/profile.d/nix.sh ]] && source ~/.nix-profile/etc/profile.d/nix.sh

# Load GVM if available (lazy)
lazy_load_gvm() {
  unfunction lazy_load_gvm gvm 2>/dev/null
  [[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
  if [[ $# -gt 0 ]]; then
    command "$@"
  fi
}
gvm() { lazy_load_gvm gvm "$@"; }

# Load tabtab completions
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && source ~/.config/tabtab/zsh/__tabtab.zsh

# Auto-attach tmux on mosh login (not plain SSH)
if [[ -z "$TMUX" ]] && [[ "$(ps -o comm= -p $PPID 2>/dev/null)" == "mosh-server" ]]; then
    _sessions=$(tmux list-sessions 2>/dev/null)
    _count=$(echo "$_sessions" | grep -c . 2>/dev/null)

    if [[ $_count -eq 0 ]]; then
        tmux new -s 0
    elif [[ $_count -eq 1 ]]; then
        tmux attach -t "$(echo "$_sessions" | cut -d: -f1)"
    else
        echo "tmux sessions:"
        echo "$_sessions" | nl -w1 -s') '
        echo -n "# (or n=new): "
        read _choice
        if [[ "$_choice" == "n" ]]; then
            tmux new
        else
            _target=$(echo "$_sessions" | sed -n "${_choice}p" | cut -d: -f1)
            [[ -n "$_target" ]] && tmux attach -t "$_target" || tmux new
        fi
    fi
    unset _sessions _count _choice _target
fi

# Load env file if available (uv/rustup)
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Load local config if available
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

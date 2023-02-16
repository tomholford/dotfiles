# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="mira"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "nebirhos" "mira" )

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  deno
  gh
  nvm
  rbenv
  ssh-agent
  zsh-autosuggestions
)

# Plugin Config
## nvm
### Autoload when a .nvmrc is detected
zstyle ':omz:plugins:nvm' autoload yes

# ZSH extensions
autoload zmv

## ssh-agent
### Enable agent-forwarding
zstyle :omz:plugins:ssh-agent agent-forwarding on

## oh-my-zsh
### Suppress insecure completion-dependent directories
ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh

# Set default editor
export EDITOR='vim'

# Add deno executables to path
export PATH=$HOME/.deno/bin:$PATH

# Add pwd bin and home dir to PATH
export PATH=~/bin:$PATH
export PATH=./bin:$PATH

[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
[[ -s "~/.gvm/scripts/gvm" ]] && source "~/.gvm/scripts/gvm"

export NVM_DIR="$HOME/.nvm"
if [[ $OSTYPE == 'darwin'* ]]; then
  [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh" # This loads nvm
  [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
else
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [[ $OSTYPE == 'darwin'* ]]; then
  source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

[[ -s "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

eval "$(direnv hook zsh)"

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

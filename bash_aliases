# git aliases
alias gco='git checkout'
alias gst='git status'
alias pull='git pull'
alias push='git push'
alias deletebranches='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
alias branches='git branch --list'

alias atom='atom-beta'
alias showtags='npm dist-tag ls $1'

[[ -f ~/.bash_aliases.local ]] && source ~/.bash_aliases.local

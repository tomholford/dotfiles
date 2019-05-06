alias addkeys='ssh-add -A'
alias atom='atom-beta'
alias branches='git branch --list'
alias cat='bat'
alias ping='prettyping --nolegend'
alias cleanbranches='cleanmerged && cleansquashed'
alias cleanmerged='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
alias cleansquashed='git checkout -q master && git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base master $branch) && [[ $(git cherry master $(git commit-tree $(git rev-parse $branch^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done'
alias g='git'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gcom='git checkout master'
alias gcomp='git checkout master && pull'
alias gst='git status'
alias gx='gitx'
alias pop='git stash pop'
alias pull='git pull && cleanbranches'
alias push='git push'
alias showtags='npm dist-tag ls $1'
alias stash='git stash -u'
alias ys='yarn start'
alias yb='yarn build'

[[ -f ~/.bash_aliases.local ]] && source ~/.bash_aliases.local
[[ -f ~/.bash_aliases.work ]] && source ~/.bash_aliases.work

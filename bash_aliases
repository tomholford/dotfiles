alias addkeys='ssh-add -A'
alias atom='atom-beta'
alias be='bundle exec'
alias branches='git branch --list'
alias cat='bat'
alias d='docker'
alias dc='docker-compose'
alias dce='docker-compose exec'
alias dcew='docker-compose exec web'
alias dcewbe='docker-compose exec web bundle exec'
alias dcef='docker-compose exec frontend'
alias dcefbe='docker-compose exec frontend bundle exec'
alias dev='cd ~/dev'
alias ping='prettyping --nolegend'
alias cleanbranches='cleanmerged'
# alias cleanbranches='cleanmerged && cleansquashed'
alias cleanmerged='git branch --merged | egrep -v "(^\*|master|develop)" | xargs git branch -d'
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
alias tf='terraform'
alias upgrades='apt list --upgradable'
alias unexif='mogrify -strip'
alias ys='yarn start'
alias yb='yarn build'

[[ -f ~/.bash_aliases.local ]] && source ~/.bash_aliases.local
[[ -f ~/.bash_aliases.work ]] && source ~/.bash_aliases.work

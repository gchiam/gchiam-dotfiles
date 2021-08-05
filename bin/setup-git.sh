#!/bin/sh

git config --global alias.adddiff "!git st | grep modified | sed 's/modified: //' | xargs git add"

# http://fredkschott.com/post/2014/02/git-log-is-so-2005/
git config --global alias.d "diff"
git config --global alias.dc "diff --cached"
git config --global alias.dw "diff --word-diff=color"
git config --global alias.dcw "diff --word-diff=color --cached"
git config --global alias.dwc "diff --word-diff=color --cached"
git config --global alias.dt "difftool"
git config --global alias.dtg "difftool --gui"
git config --global alias.l "log --color --graph --pretty=format:'%C(magenta)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.lg "log --all --color --graph --pretty=format:'%C(magenta)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.lm "log --color --graph --pretty=format:'%C(magenta)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit master..."
git config --global alias.lmn "log --color --graph --pretty=format:'%C(magenta)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit main..."
git config --global alias.lo "log --color --graph --pretty=format:'%C(magenta)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit origin/HEAD..."
git config --global alias.standup "log --color --pretty=format:'%C(magenta)%h%Creset -%Creset %s %Cgreen(%cD) %C(bold blue)<%an>%Creset' --since='1 week ago' --author gchiam"

git config --global alias.br "branch"
git config --global alias.bo 'branch --all --verbose --verbose'
git config --global alias.bom 'branch --all --list "*gchiam*" --verbose --verbose'
git config --global alias.bv 'branch --verbose --verbose'
git config --global alias.bvm 'branch --list "*gchiam*" --verbose --verbose'
git config --global alias.cleanup '!git branch --merged | grep -v "*\|main|master" | xargs -n 1 git branch -d'
git config --global alias.cbr "rev-parse --abbrev-ref HEAD"
git config --global alias.co "checkout"
git config --global alias.cp "cherry-pick"
git config --global alias.main "checkout main"
git config --global alias.mn "checkout main"
git config --global alias.master "checkout master"
git config --global alias.ms "checkout master"
git config --global alias.ci "commit"
git config --global alias.pl "pull"
git config --global alias.plp "pull --prune"
git config --global alias.s "status -sb"
git config --global alias.search "log --no-merges -i -E --pretty='%C(magenta)%h%Creset %C(green)(%ad, %Cgreen%cr)%Creset %C(bold blue)<%an>%Creset %s %C(yellow)%d%Creset' --date=format:'%b %d %Y' --grep"
git config --global alias.sm "submodule"
git config --global alias.st "status -b"
git config --global alias.unstage "reset HEAD --"

git config --global alias.last "log -1 HEAD"
git config --global pull.rebase false

# diff
git config --global diff.tool "vimdiff"
git config --global diff.guitool "opendiff"
git config --global difftool.prompt "no"
git config --global difftool.vimdiff.cmd "nvim -d \"\$LOCAL\" \"\$REMOTE\""
git config --global difftool.opendiff.cmd "opendiff \"\$LOCAL\" \"\$REMOTE\""
git config --global merge.tool "vimdiff"
git config --global mergetool.prompt "true"
git config --global mergetool.vimdiff.cmd "nvim -d \"\$LOCAL\" \"\$REMOTE\" \"\$MERGED\" -c '\$wincmd w' -c 'wincmd J'"

# git config --global pager.diff "diff-so-fancy | less --tabs=8 -RFX"
# git config --global pager.show "diff-so-fancy | less --tabs=8 -RFX"
git config --global core.pager "delta --theme='Nord' --plus-color='#142e26' --minus-color='#2b1618'"
git config --global interactive.diffFilter "delta --color-only"

# colors
git config --global color.ui "true"
git config --global color.pager "true"

git config --global color.branch.current "green bold"
git config --global color.branch.local "normal"
git config --global color.branch.remote "blue bold"
git config --global color.branch.plain "normal"
git config --global color.diff.meta "yellow"
git config --global color.diff.frag "cyan reverse"
git config --global color.diff.old "red bold"
git config --global color.diff.new "green bold"
git config --global color.diff.plain "normal"
git config --global color.diff.commit "magenta reverse"
git config --global color.diff.whitespace "normal"
git config --global color.grep.context "normal"
git config --global color.grep.filename "magenta bold reverse"
git config --global color.grep.linenumber "cyan"
git config --global color.grep.match "green bold reverse"
git config --global color.grep.selected "green"
git config --global color.grep.separator "cyan"
git config --global color.status.header "normal"
git config --global color.status.added "green bold"
git config --global color.status.changed "red bold"
git config --global color.status.untracked "yellow"
git config --global color.status.nobranch "cyan"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(sudo git zsh-syntax-highlighting colored-man-pages fzf-zsh-plugin fzf-tab)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run p10k configure or edit ~/.p10k.zsh.
[[ ! -f ''${ZDOTDIR:-$HOME}/.p10k.zsh ]] || source ''${ZDOTDIR:-$HOME}/.p10k.zsh
export PATH="$PATH:/opt/nvim/"
alias ugoon="fusermount -u ~/.decrypted"
alias igoons="encfs ~/.encrypted ~/.decrypted"

# YT-DLP and VCPKG paths
export VCPKG_ROOT=/home/lysander/vcpkg:$PATH
export PATH=$VCPKG_ROOT:$PATH
export PATH=$/home/qwerty/scdl-env/bin/:$PATH
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/home/qwerty/go/bin

# Aliases
alias nvchad='NVIM_APPNAME=nvchad nvim'
alias n='nvim'
alias lysander-git='git config user.name "Lysandercodes" && git config user.email "lysander2006@proton.me"'
alias showgitcreds='git config --list'
alias lysandergitsshcommand='export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_anon"'
alias ui='~/code/snippetbox/ui/html/pages'
alias html2tmpl='for f in *.html; do mv -- "$f" "${f%.html}.tmpl"; done'
alias tmpl2html='for f in *.tmpl; do mv -- "$f" "${f%.tmpl}.html"; done'
alias todo_update='notes.sh ~/text/todo-TODAY'
alias flatpak-builder='flatpak run org.flatpak.Builder'
alias vc='cd ~/.config/nvim/ && nvim'
alias vs='cd ~/NixOSenv/ && nvim'
alias charlie-kirk='cd ~/Charlie-Kirkification-nix-support/charlie-kirk-project && nix-shell --run "python main.py"'
alias nr="cd ~qwerty/NixOSenv && lysander-git && git -C ~/NixOSenv add . && sudo nixos-rebuild switch --flake ~/NixOSenv#nixos"
alias c='cmus'

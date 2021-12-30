# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export TERM=xterm

bindkey '^[[1;5C' emacs-forward-word
bindkey '^[[1;5D' emacs-backward-word
bindkey '\e[3~' delete-char

# Aliases
alias spt='searchsploit'

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=5'


PROMPT_EOL_MARK=""

# Functions
# Make working directories
function mkt() {
    mkdir enumeration extras scripts 
}

function PSCredential () {
    echo -e "\n\t[+] \$user = 'user'"
    echo -e "\t[+] \$pw = 'password'"
    echo -e "\t[+] \$secpw = ConvertTo-SecureString \$pw -AsPlainText -Force"
    echo -e "\t[+] \$cred = New-Object System.Management.Automation.PSCredential \$user, \$secpw"
    echo -e "\t[+] Invoke-Command -ComputerName localhost -Credential \$cred -ScriptBlock { whoami }"
}

# cd back any number of folders
function cdb() {
    folderBack=""
    if [[ $# > 0 && $1 > 0 ]]
    then
        for ((counter = 0; counter < $1; counter ++))
        do
            folderBack+="../"
        done
        cd $folderBack
    else
        cd ../
    fi
}

# Extract nmap information
function extractPorts(){
    ports="$(cat $1 | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
    ip_address="$(cat $1 | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u | head -n 1)"
    echo -e "\n[*] Extracting information...\n" > extractPorts.tmp
    echo -e "\t[*] IP Address: $ip_address"  >> extractPorts.tmp
    echo -e "\t[*] Open ports: $ports\n"  >> extractPorts.tmp
    echo $ports | tr -d '\n' | xclip -sel clip
    echo -e "[*] Ports copied to clipboard\n"  >> extractPorts.tmp
    cat extractPorts.tmp; rm extractPorts.tmp
}

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /home/lepra/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
unsetopt autocd beep extendedglob
bindkey -e
# End of lines configured by zsh-newuser-install

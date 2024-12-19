#!/bin/bash

# Variables
USERNAME="admin"
STARSHIP_CONFIG_PATH="$HOME/.config/starship.toml"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
KUBECONFIG_PATH="$HOME/.kube/config"

# Actualización e instalación de dependencias necesarias
echo "Actualizando sistema e instalando dependencias..."
sudo apt update && sudo apt install -y zsh git curl wget ssh

# Cambiar shell a Zsh
echo "Cambiando shell a Zsh..."
chsh -s $(which zsh)

# Instalar Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Instalando Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh ya está instalado."
fi

# Instalar plugins de Zsh
echo "Instalando plugins de Zsh..."
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# Configuración de Starship
if [ ! -f "$STARSHIP_CONFIG_PATH" ]; then
    echo "Configurando Starship..."
    mkdir -p "$(dirname "$STARSHIP_CONFIG_PATH")"
fi

# Crear archivo starship.toml con la configuración especificada
cat > "$STARSHIP_CONFIG_PATH" <<EOL
# Get editor completions based on the config schema
"\$schema" = 'https://starship.rs/config-schema.json'

# Inserts a blank line between shell prompts
add_newline = true

# Replace the '❯' symbol in the prompt with '➜'
[character]
success_symbol = '[➜](bold green)'

# Disable the package module, hiding it from the prompt completely
[package]
disabled = true

#---------Configs StartShip-----------#

# ~/.config/starship.toml

# Configuración general
add_newline = false
prompt_order = [
    "username",
    "hostname",
    "directory",
    "git_branch",
    "git_status",
    "docker_context",
    "kubernetes",
    "aws",
    "terraform",
    "python",
    "nodejs",
    "package",
    "memory_usage",
    "character"
]

[directory]
truncation_length = 3

[git_branch]
symbol = "🌱 "
truncation_length = 12

[git_status]
conflicted = "⚔️ "
ahead = "🔼 "
behind = "🔽 "
untracked = "🔧 "

[docker_context]
symbol = "🐳 "

[kubernetes]
symbol = "☸️  "
context_aliases = { "minikube" = "mk", "default" = "df" }

[aws]
symbol = "☁️ "
format = "on [\$profile](\$style) "

[terraform]
symbol = "💠 "
format = "via [\$version](\$style) "

[python]
symbol = "🐍 "
pyenv_version_name = true

[nodejs]
symbol = "⬢ "

[memory_usage]
symbol = "💻 "
threshold = 70

[custom.zsh]
command = "echo 🚀"
when = true

[localip]
ssh_only = false
format = '@[\$localipv4](bold red) '
disabled = false
EOL

# Crear archivo .zshrc con la configuración especificada
echo "Configurando archivo .zshrc..."
cat > "$HOME/.zshrc" <<EOL
export ZSH="\$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source \$ZSH/oh-my-zsh.sh

# Configuración de Starship
eval "\$(starship init zsh)"
export STARSHIP_CONFIG=$STARSHIP_CONFIG_PATH

# Configuración de KUBECONFIG
export KUBECONFIG=$KUBECONFIG_PATH:$KUBECONFIG_PATH-rancher:$KUBECONFIG_PATH-mini

# Alias
alias ll='ls -lah'
alias jaguar='ssh -p 4322 $USERNAME@181.60.247.237'
alias kdev='kubectl config use-context cluster-inlaze'
alias kprod='kubectl config use-context prod-eks-cluster'
alias kmini='kubectl config use-context minikube'

alias deadpool='ssh -p 4322 admin@deadpool.inlazetest.com'
alias spiderman='ssh -p 4322 admin@spiderman.inlazetest.com'
alias hulk='ssh -p 4322 admin@hulk.inlazetest.com'
alias ironman='ssh -p 4322 admin@ironman.inlazetest.com'
alias blackpanther='ssh -p 4322 admin@blackpanther.inlazetest.com'
alias thor='ssh -p 4322 admin@thor.inlazetest.com'
alias blackwidow='ssh -p 4322 admin@blackwidow.inlazetest.com'
alias wolverine='ssh -p 4322 admin@wolverine.inlazetest.com'
alias initgit='eval \$(ssh-agent -s)'
alias keygit='ssh-add /home/$USERNAME/Documents/key_ssh_github/key_inlaze'
alias kb='kubectl'

# NVM
export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"
EOL

# Finalización
echo "Configuración completada. Reinicia tu terminal para aplicar los cambios."

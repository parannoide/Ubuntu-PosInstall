#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #
PPA_LIBRATBAG="ppa:libratbag-piper/piper-libratbag-git"
PPA_GRAPHICS_DRIVERS="ppa:graphics-drivers/ppa"

URL_WINE_KEY="https://dl.winehq.org/wine-builds/winehq.key"
URL_PPA_WINE="https://dl.winehq.org/wine-builds/ubuntu/"
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"

DIRETORIO_DOWNLOADS="$HOME/Downloads/programas"

APT_APPS=(
    git
    python3
    openssl
    openvpn
    cups
    firefox
    flatpak
    google-chrome-stable
    grub-customizer
    htop
    vim
    snapd
    ratbagd
    piper
    zsh
    gnome-software-plugin-flatpak
    apt-transport-https
    curl
    gnupg
    keepassxc
    glogg
)
FLAT_APPS=(
    com.skype.Client
    io.dbeaver.DBeaverCommunity
    com.getpostman.Postman
    org.filezillaproject.Filezilla
    org.libreoffice.LibreOffice
)

SNAP_APPS=(
    gimp
    rocketchat-desktop
)


# ---------------------------------------------------------------------- #

# ----------------------------- REQUISITOS ----------------------------- #
## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

## Adicionando/Confirmando arquitetura de 32 bits ##
sudo dpkg --add-architecture i386

## Atualizando o repositório ##
sudo apt update -y

## Adicionando repositórios de terceiros e suporte a Snap (Driver Logitech, Lutris e Drivers Nvidia)##
sudo apt-add-repository "$PPA_LIBRATBAG" -y
sudo apt-add-repository "$PPA_GRAPHICS_DRIVERS" -y
wget -nc "$URL_WINE_KEY"
sudo apt-key add winehq.key
sudo apt-add-repository "deb $URL_PPA_WINE bionic main"


# ---------------------------------------------------------------------- #

# ----------------------------- EXECUÇÃO ----------------------------- #
## Atualizando o repositório depois da adição de novos repositórios ##
sudo apt update -y

## Download e instalaçao de programas externos ##
mkdir "$DIRETORIO_DOWNLOADS"
wget -c "$URL_GOOGLE_CHROME"       -P "$DIRETORIO_DOWNLOADS"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DIRETORIO_DOWNLOADS/*.deb

# Instalar programas no apt
for nome_do_programa in ${APT_APPS[@]}; do
    echo "Instalando: $nome_do_programa"
    sudo apt install "$nome_do_programa" -y
done

## Instalando pacotes Flatpak ##
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Instalando pacotes Snap ##
for nome_do_programa in ${SNAP_APPS[@]}; do
    echo "Instalando: $nome_do_programa"
    sudo flatpak install flathub "$nome_do_programa"
done

## Instalando pacotes Snap ##
for nome_do_programa in ${SNAP_APPS[@]}; do
    echo "Instalando: $nome_do_programa"
    sudo snap install "$nome_do_programa"
done

# ---------------------------------------------------------------------- #

# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza##
sudo apt update && sudo apt dist-upgrade -y
flatpak update
sudo apt autoclean
sudo apt autoremove -y
# ---------------------------------------------------------------------- #

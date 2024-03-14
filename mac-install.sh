#!/bin/bash

# Install Packer

brew update && brew upgrade && brew upgrade --cask
brew tap epk/epk
brew tap homebrew/cask-fonts
brew tap homebrew/cask-versions

brew install --cask \
    amethyst \
    azure-data-studio \
    aws-vpn-client \
    blender \
    discord \
    docker \
    firefox \
    firefox-developer-edition \
    font-fira-code \
    font-monaspace \
    font-sf-mono-nerd-font \
    font-jetbrains-mono \
    google-chrome \
    jetbrains-toolbox \
    karabiner-elements \
    keymapp \
    kitty \
    microsoft-remote-desktop \
    microsoft-teams \
    mysqlworkbench \
    obs \
    obsidian \
    postman \
    qt-creator \
    signal \
    sony-ps-remote-play \
    sublime-merge \
    sublime-text \
    telegram \
    tradingview \
    visual-studio-code-insiders \
    whatsapp

brew install \
    ack \
    asdf \
    autoconf \
    autoconf-archive \
    automake \
    awscli \
    bash-language-server \
    boost \
    cmake \
    curl \
    deno \
    fd \
    ffmpeg \
    flyway \
    gawk \
    gcc \
    gh \
    giflib \
    git \
    gnupg \
    gnutls \
    gopls \
    grpc \
    haskell-language-server \
    imagemagick \
    jansson \
    java \
    jpeg \
    kotlin-language-server \
    libgccjit \
    libpng \
    librsvg \
    libtiff \
    llvm \
    lua-language-server \
    lua \
    luarocks \
    mariadb \
    nasm \
    neovim \
    ninja \
    openssh \
    pinentry-mac \
    postgresql@15 \
    protobuf \
    pyright \
    python@3.10 \
    qt \
    ripgrep \
    rust-analyzer \
    rustup-init \
    shellcheck \
    steam \
    texinfo \
    tree-sitter \
    wget \
    yaml-language-server \
    ykman \
    yubico-authenticator \
    yubico-piv-tool \
    zsh

echo "SHOULD INSTALL GLOBAL NODEJS: asdf global nodejs latest"

# Install language servers
npm i -g  @angular/language-server \
          cssmodules-language-server \
          dockerfile-language-server-nodejs \
          dot-language-server \
          emmet-ls \
          eslint_d \
          intelephense \
          graphql-language-service-cli \
          typescript \
          typescript-language-server \
          vls \
          vscode-css-languageservice \
          vscode-langservers-extracted


# Change this so it only does rustup-init if it wasn't run before
rustup-init
rustup component add clippy
rustup toolchain install nightly
rustup +nightly component add miri

pip3 install cmake-language-server


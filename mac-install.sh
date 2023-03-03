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
    font-sf-mono-nerd-font \
    google-chrome \
    jetbrains-toolbox \
    kitty \
    microsoft-remote-desktop \
    microsoft-teams \
    mysqlworkbench \
    obs \
    postman \
    signal \
    sublime-merge \
    sublime-text \
    telegram \
    trader-workstation \
    tradingview \
    whatsapp

brew install \
    ack \
    asdf \
    autoconf \
    awscli \
    bash-language-server \
    boost \
    cmake \
    curl \
    deno \
    fd \
    ffmpeg \
    gawk \
    git \
    gnupg \
    gopls \
    haskell-language-server \
    java \
    kotlin-language-server \
    llvm \
    lua-language-server \
    lua \
    luarocks \
    mariadb \
    neovim \
    ninja \
    pinentry-mac \
    pyright \
    ripgrep \
    rust-analyzer \
    rustup-init \
    shellcheck \
    yaml-language-server \
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

cargo install taplo-lsp

pip3 install cmake-language-server


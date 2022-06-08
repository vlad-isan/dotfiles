#!/bin/bash

# Install Packer

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

brew update && brew upgrade && brew upgrade --cask
brew tap epk/epk
brew tap homebrew/cask-fonts

brew install --cask \
              font-fira-code \
              font-sf-mono-nerd-font \
              kitty \
              microsoft-remote-desktop \
              trader-workstation \
              tradingview

brew install  ack \
              bash-language-server \
              deno \
              fd \
              gopls \
              haskell-language-server \
              kotlin-language-server \
              lua-language-server \
              lua \
              luarocks \
              neovim \
              pinentry \
              pinentry-mac \
              pyright \
              ripgrep \
              rust \
              shellcheck \
              yaml-language-server

cargo install taplo-lsp

pip3 install cmake-language-server


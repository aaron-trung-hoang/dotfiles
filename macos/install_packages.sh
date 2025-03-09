#!/bin/bash

if [ -f ~/Brewfile ]; then
    echo "Backing up existing Brewfile"
    mv ~/Brewfile ~/Brewfile.backup
fi

echo "Copying Brewfile to home directory"
cp ./macos/Brewfile ~/

brew bundle --file=~/Brewfile

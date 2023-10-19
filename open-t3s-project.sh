#!/bin/bash
# sudo service postgresql start > /dev/null 2>&1

# VARIABLES
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DEFAULT_PROJECT_DIR=~/Projects

function createSession {
    cd $DEFAULT_PROJECT_DIR/$PROJECT_NAME
    tmux new-session -d -s main -n Neovim "nvim .; zsh -i" 
    tmux new-window -d -t main: -n Tunnel "$SCRIPT_DIR/tunnel.sh; zsh -i"
    tmux new-window -d -t main: -n Prisma "cd packages/db && yarn dev; zsh -i"
}

while getopts :p:l FLAGS;
do
    case $FLAGS in
        l)
            cd $DEFAULT_PROJECT_DIR 
            ls -A --color=auto 
            ;;
        p)
            PROJECT_NAME=$OPTARG
            createSession
            ;;
        ?)
            echo "Error: -$OPTARG is not an option"
            ;;
    esac
done



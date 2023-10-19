#!/bin/bash

#VARIABLES
PORT=3000

#FUNCTIONS
function startTunnel {
    if [ -z "$LT_PID" ]; then
        echo ""

        lt --port $PORT &
        LT_PID=$!        

        sleep 1 
        echo ""
        echo "Tunnel running on port $PORT ..."
        echo ""
        echo "-- Hit 'r' to restart tunnel" 
        echo "-- Hit 'q' to quit"
        echo ""
    fi        
}

function stopTunnel {
    if [ -n "$LT_PID" ]; then
        kill "$LT_PID"
        wait "$LT_PID"
        LT_PID=""
    fi
}

function restartTunnel {
    stopTunnel

    echo ""
    echo "Restarting tunnel .."
    echo ""

    startTunnel
}

#OPTS
while getopts :p: FLAGS;
do
    case $FLAGS in
        p)
            PORT=$OPTARG
            ;;
        ?)
            echo "Error: -$OPTARG is not an option"
            ;;
    esac
done


startTunnel

while :; do
    read -rsn 1 key
    
    case "$key" in
        r)
            restartTunnel
            ;;
        q)  
            stopTunnel
            break
            ;;
        *)  
            ;;
    esac
done

#!/bin/bash

docker build -t delta_quickstart -f Dockerfile_delta_quickstart .

# Build entry point
docker run --name delta_quickstart --rm -it -p 8888-8889:8888-8889 delta_quickstart

server_ports_used=("8889")


#check if the user wants to exit
    #If yess, kill all the processes running fastapi / guinicorn
    for m_port in "${server_ports_used[@]}"
    do

        pid_to_kill=$(lsof -t -i :$m_port -s TCP:LISTEN)

        echo "pid_to_kill=$pid_to_kill"

        #Check if the variable is defined and if it has values
        #and if it has values in it.
        if [[ $pid_to_kill && ${pid_to_kill-_} ]]; then
        for ptk in "${pid_to_kill[@]}" ; do
            sudo kill -9 ${ptk}
        done
        fi

    done

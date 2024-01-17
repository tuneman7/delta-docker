#!/bin/bash

# Function to check if docker image exists
check_docker_image() {
    docker image inspect $1 > /dev/null 2>&1
    return $?
}

# Image name
IMAGE_NAME="delta_quickstart"

# Check if the Docker image already exists
if check_docker_image $IMAGE_NAME; then
    echo "Docker image $IMAGE_NAME already exists. Do you want to rebuild it? [y/N]"
    
    # Read user input, timeout after 2 seconds, default to No
    read -t 2 -p "Rebuild? (y/N): " REBUILD
    REBUILD=${REBUILD:-n}

    # Rebuild docker image if user input is 'y'
    if [[ $REBUILD =~ ^[Yy]$ ]]; then
        docker build -t $IMAGE_NAME -f Dockerfile_delta_quickstart .
    fi
else
    # Build the docker image if it doesn't exist
    docker build -t $IMAGE_NAME -f Dockerfile_delta_quickstart .
fi

# Run the Docker container in background
docker run --name $IMAGE_NAME --rm -p 8888-8889:8888-8889 $IMAGE_NAME

echo "Docker container $IMAGE_NAME is running in background."

# Prompt for teardown
read -p "Do you want to teardown the Docker container? (y/N): " TEARDOWN

if [[ $TEARDOWN =~ ^[Yy]$ ]]; then
    # Stop and remove the Docker container
    docker stop $IMAGE_NAME

    echo "Docker container $IMAGE_NAME has been stopped and removed."

    # Additional teardown steps can be added here
fi

server_ports_used=("8888")


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

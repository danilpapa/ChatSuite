#!/bin/bash

open -a "Docker"

while ! docker info > /dev/null 2>&1; do
    sleep 1
done

docker-compose up db
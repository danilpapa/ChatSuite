#!/bin/bash

open -a "Docker"

while ! docker info > /dev/null 2>&1; do
    sleep 1
done

# TODO: Upd osapplscript
osascript -e 'tell application "Docker" to set miniaturized of every window to true'

docker-compose up db
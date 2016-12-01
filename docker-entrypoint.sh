#!/bin/bash

URL=https://gitlab.com/ci

# Check config file
if [[ -e /etc/gitlab-runner/config.toml ]] ; then
    # Check config is available
    if [[ $(gitlab-runner verify --delete 2>&1 | grep 'is alive' | wc -l) -eq 0 ]] ; then
        # Register runner
        /entrypoint register --non-interactive --leave-runner --url $URL
    fi
else
    # Register runner
    /entrypoint register --non-interactive --leave-runner --url $URL
fi

# Check config file
if [[ -e /etc/gitlab-runner/config.toml ]] ; then
    # Unregister runner
    TOKEN=$(gitlab-runner list 2>&1 | grep -o "Token.*" | awk -F' ' '{ print $1}' | awk -F'=' '{ print $2}')
    echo TOKEN=$TOKEN
    trap "/entrypoint unregister --url $URL --token $TOKEN ; exit" SIGINT SIGTERM SIGKILL

    # Start runner
    /entrypoint run --working-directory=/home/gitlab-runner
fi

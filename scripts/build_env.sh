#!/bin/bash

grep 'docker\|lxc' /proc/1/cgroup > /dev/null 2>&1 || {
    echo This script should only be called in a container. Consult the README for instructions
    exit 1
}

mkdir -p /root/.ssh
ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
echo "export PROMPT_COMMAND='history -a' export HISTFILE=/root/.bash_history" >> /root/.bashrc
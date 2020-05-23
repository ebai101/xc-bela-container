#!/bin/bash

mkdir -p /root/.ssh
ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts
echo "export PROMPT_COMMAND='history -a' export HISTFILE=/root/.bash_history" >> /root/.bashrc
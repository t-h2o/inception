#!/bin/sh

# Create a user
yes 1234 | adduser paul

# Generate ssh key for the ssh daemon
/usr/bin/ssh-keygen -t ed25519 -N '' -f /root/.ssh/id_ed25519

# Run sshd without detach
/usr/sbin/sshd -h /root/.ssh/id_ed25519 -D

#!/bin/sh
echo 'Generating SSH host keys'
/usr/bin/ssh-keygen -A

echo 'Starting SSH daemon'
/usr/sbin/sshd -D

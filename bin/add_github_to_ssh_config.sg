#!/bin/bash

test -e ~/.ssh/config || (touch ~/.ssh/config && chmod 400 ~/.ssh/config)
grep -q github ~/.ssh/config || cat > ~/.ssh/config << EOF

Host github.com
    HostName ssh.github.com
    IdentityFile ~/.ssh/gordon.chiam@gmail.com

EOF

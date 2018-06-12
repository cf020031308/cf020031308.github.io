# Building Git Repositories at Cloud

Take Aliyun ECS as an example

1. Ensure `git` is installed

        apt-get install git

2. Add a user which logins in with `git-shell` to maintain repositories

        adduser git  # whether called git is not important
        sed -i "\$s,/bin/bash,`which git-shell`,g" /etc/passwd 
        mkdir /home/git/.ssh
        wget https://github.com/cf020031308.keys -O /home/git/.ssh/authorized_keys

3. Create a git repository `test.git` for instance

        cd /home/git && git init --bare test.git && chown -R git:git test.git

4. Clone from anywhere

        git clone git@host:/home/git/test.git

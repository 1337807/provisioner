#!/usr/bin/sh

useradd -m jonan -g sudo
passwd jonan
apt-get -y install git
apt-get -y install vim
su - jonan -c 'mkdir /home/jonan/.ssh'
su - jonan -c 'curl https://github.com/1337807.keys > /home/jonan/.ssh/authorized_keys'
su - jonan -c 'chsh -s /bin/bash'
su - jonan -c 'curl -L https://get.rvm.io | bash -s stable --ruby --gems=rake'
su - jonan -c 'rvm gemset use global'
su - jonan -c 'gem install rake'
su - jonan -c 'git clone git://github.com/1337807/dotvim.git /home/jonan/.vim'
su - jonan -c 'ln -s /home/jonan/.vim/vimrc /home/jonan/.vimrc'
su - jonan -c 'cd /home/jonan/.vim && git submodule init && git submodule update'
su - jonan -c 'cd /home/jonan/.vim/bundle/snipmate_snippets && rvm gemset use global && rake install'
su - jonan -c 'git clone https://github.com/1337807/powerline-shell /home/jonan/powerline-shell'
su - jonan -c '/home/jonan/powerline-shell/install.py'
su - jonan -c 'ln -s /home/jonan/powerline-shell/powerline-shell.py /home/jonan/powerline-shell.py'
apt-get update
apt-get -y install software-properties-common
add-apt-repository -y ppa:dotcloud/lxc-docker
sh -c "curl http://get.docker.io/gpg | apt-key add -"
apt-get update
apt-get -y install lxc-docker
su - jonan -c 'git clone https://github.com/1337807/docker-znc.git /home/jonan/docker-znc'
cd /home/jonan/docker-znc
docker build .

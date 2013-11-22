#!/bin/bash

echo '======================================='
echo 'Adding user jonan...'
echo '======================================='
useradd -m jonan -g sudo
echo 'Enter password for jonan.'
passwd jonan
chsh jonan -s /bin/bash

echo '======================================='
echo 'Installing git...'
echo '======================================='
apt-get -y install git

echo '======================================='
echo 'Installing vim...'
echo '======================================='
apt-get -y install vim

echo '======================================='
echo 'Copying public key from github...'
echo '======================================='
su - jonan -c 'mkdir /home/jonan/.ssh'
su - jonan -c 'curl https://github.com/1337807.keys > /home/jonan/.ssh/authorized_keys'
su - jonan -c 'cp /home/jonan/.ssh/authorized_keys /home/jonan/.ssh/id_rsa.pub'

echo '======================================='
echo 'Installing vim configuration...'
echo '======================================='
su - jonan -c 'git clone git://github.com/1337807/dotvim.git /home/jonan/.vim'
su - jonan -c 'ln -s /home/jonan/.vim/vimrc /home/jonan/.vimrc'
su - jonan -c 'cd /home/jonan/.vim && git submodule init && git submodule update'
su - jonan -c 'cd /home/jonan/.vim/bundle/snipmate_snippets && rake install'

echo '======================================='
echo 'Installing powerline-shell...'
echo '======================================='
su - jonan -c 'git clone https://github.com/1337807/powerline-shell /home/jonan/powerline-shell'
su - jonan -c '/home/jonan/powerline-shell/install.py'
su - jonan -c 'ln -s /home/jonan/powerline-shell/powerline-shell.py /home/jonan/powerline-shell.py'

echo '======================================='
echo 'Installing docker...'
echo '======================================='
apt-get update
apt-get -y install software-properties-common
apt-get -y install linux-image-extra-`uname -r`
add-apt-repository -y ppa:dotcloud/lxc-docker
sh -c "curl http://get.docker.io/gpg | apt-key add -"
apt-get update
apt-get -y install lxc-docker

echo '======================================='
echo 'Installing docker-znc...'
echo '======================================='
su - jonan -c 'git clone https://github.com/1337807/docker-znc.git /home/jonan/docker-znc'
cd /home/jonan/docker-znc
docker build .

echo '======================================='
echo 'Installing fish...'
echo '======================================='
apt-get -y install fish
su - jonan -c 'touch /home/jonan/.config/fish/config.fish'

echo '======================================='
echo 'Installing oh-my-fish...'
echo '======================================='
su - jonan -c 'cd /home/jonan'
su - jonan -c 'curl -L https://github.com/bpinto/oh-my-fish/raw/master/tools/install.sh | sh'

echo '======================================='
echo 'Installing rvm...'
echo '======================================='
apt-get update
su - jonan -c 'curl -L https://get.rvm.io | bash'
su - jonan -c 'curl --create-dirs -o ~/.config/fish/functions/rvm.fish https://raw.github.com/lunks/fish-nuggets/master/functions/rvm.fish'

echo '======================================='
echo 'Installing ruby...'
echo '======================================='
echo 'try using sudo instead of su, or flag on su to use login shell'
echo 'the dash seems to be the flag that uses a login shell'
echo 'specify an askpass program somehow?'
su - jonan -c 'rvm install 2.0'
su - jonan -c 'source /home/jonan/.rvm/scripts/rvm'
su - jonan -c 'rvm gemset use global && gem install rake'

echo '======================================='
echo 'Installing dotfiles...'
echo '======================================='
su - jonan -c 'git clone https://github.com/1337807/dotfiles.git /home/jonan/dotfiles'
su - jonan -c 'cd /home/jonan/dotfiles && rake install'

echo '======================================='
echo 'Changing shell to fish...'
echo '======================================='
echo '/usr/bin/fish' >> /etc/shells
su jonan
chsh -s /usr/bin/fish
exit

cp sshd_config /etc/ssh/sshd_config
restart ssh

echo '*********************************************************************'
echo "* Don't forget to disable root login and password authentication in *"
echo "* /etc/ssh/sshd_config (PermitRootLogin & PasswordAuthentication)   *"
echo "* then `restart ssh`.                                               *"
echo '*********************************************************************'

#!/usr/bin/env bash
apt-get -y update
apt-get -y install build-essential libyaml-dev zlib1g-dev openssl libssl-dev lib64readline-gplv2-dev
cd /tmp
wget ftp://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.gz
tar -xvzf ruby-2.0.0-p247.tar.gz
cd ruby-2.0.0-p247/
./configure --prefix=/usr/local
make
make install
gem install chef ruby-shadow --no-ri --no-rdoc

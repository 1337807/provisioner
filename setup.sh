#!/usr/bin/env bash
apt-get -y update
apt-get install -y make gcc
apt-get install -y curl git-core python-software-properties
apt-get install -y build-essential zlib1g-dev libyaml-dev libssl-dev
apt-get install -y libgdbm-dev libreadline6-dev libncurses5-dev
apt-get install -y libpq-dev libffi-dev
cd /tmp
wget ftp://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p247.tar.gz
tar -xvzf ruby-2.0.0-p247.tar.gz
cd ruby-2.0.0-p247/
./configure --prefix=/usr/local
make
make install
gem install chef ruby-shadow --no-ri --no-rdoc

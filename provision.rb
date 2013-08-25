#!/usr/bin/ruby
require 'net/ssh'
require 'highline/import'

if ARGV.length < 1
  puts "Usage: ruby provision 127.0.0.1"
  exit
end

class Provisioner
  attr_reader :host, :ssh_connection
  attr_accessor :new_user

  def initialize
    @host = ARGV[0]
    @new_user = nil
    @ssh_connection = open_connection_to_host(self.host)
    unless @ssh_connection
      puts "Failed to initiate connection to #{self.host}."
      exit
    end
  end

  def open_connection_to_host(host)
    puts "Connecting to #{host}."

    tries = 0

    begin
      user = ask("User: ") { |q| q.default = "root" }
      password = ask("Password:  ") { |q| q.echo = "*" }
      Net::SSH.start(host, 'root', :password => password)
    rescue Net::SSH::AuthenticationFailed => e
      puts "Authentication failed, try again."
      if tries < 3
        tries += 1
        retry
      end
    end
  end

  def setup_host
    puts "Creating a new user account."
    user = ask("New user: ") { |q| q.default = "jonan" }
    password = ask("New user's password:  ") { |q| q.echo = "*" }
    run_command("useradd -m #{user} -p #{password} -g sudo")
    self.new_user = user

    puts "Creating ssh directory."
    run_command("mkdir /home/jonan/.ssh")
    puts "Copying public key to .ssh/authorized_keys"
    run_command("curl https://github.com/1337807.keys > /home/jonan/.ssh/authorized_keys")

    puts "Setting shell to bash."
    run_command("chsh -s /bin/bash jonan")

    puts "Installing git."
    install("git")

    puts "Installing vim."
    install("vim")

    puts "Installing RVM with ruby and rake."
    install_rvm

    vim_config = ask("Install vim configuration for #{user}?") { |q| q.default = "yes" }
    setup_vim_config if vim_config == 'yes'
  end

  def setup_vim_config
    home = "/home/#{self.new_user}"
    run_command("git clone git://github.com/1337807/dotvim.git /home/#{self.new_user}/.vim")
    run_command("ln -s #{home}/.vim/vimrc #{home}/.vimrc")
    run_command("cd #{home}/.vim && git submodule init && git submodule update")
    run_command("cd #{home}/.vim/bundle/snipmate_snippets && rvm gemset use global && rake install")
  end

  def install(package)
    run_command("apt-get -y update")
    run_command("apt-get -y install #{package}")
  end

  def install_rvm
    run_command("su jonan && curl -L https://get.rvm.io | bash -s stable --ruby --gems=rake")
    run_command("su jonan && source ~/.rvm/scripts/rvm")
    run_command("su jonan && rvm gemset use global")
    run_command("su jonan && gem install rake")
  end

  def run_command(cmd)
    output = self.ssh_connection.exec!(cmd)
    puts output
  end
end

Provisioner.new.setup_host

package 'git-core'
package 'vim'

user node[:user][:name] do
  password node[:user][:password]
  gid "sudo"
  home "/home/#{node[:user][:name]}"
  supports manage_home: true
  shell "/bin/bash"
end

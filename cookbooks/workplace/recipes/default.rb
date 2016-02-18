#
# Cookbook Name:: workplace
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

user 'vik' do
 home "/home/vik"
 shell '/bin/bash'
 password '$1$kebqEp1T$KtW7brg4hPfNZcCmK0yk11'
end

package 'epel-release'
package ['vim', 'tmux', 'git', 'zip', 'unzip']

git '/tmp/vim_colors' do
  repository 'https://github.com/tomasr/molokai.git'
end

%w(/root /home/vik).each do |path|
  directory "#{path}/.vim/colors" do
    recursive true
	action :create
  end

  execute 'copy molokai style' do
    command "cp /tmp/vim_colors/colors/molokai.vim #{path}/.vim/colors/molokai.vim"
  end

  %w(bashrc vimrc tmux.conf).each do |file|
  	template "#{path}/.#{file}" do
      source "#{file}.erb"
	  variables(
	  'path' => path
	  )
	end
  end
end

remote_file '/tmp/awscli-bundle.zip' do
  source 'https://s3.amazonaws.com/aws-cli/awscli-bundle.zip'
  mode 755
  action :create_if_missing
 end
 
execute 'install aws-cli' do
  command <<-EOF
    sudo unzip -o /tmp/awscli-bundle.zip
    sudo /tmp/awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
  EOF
  cwd '/tmp'
  not_if { File.exists?('/tmp/awscli-bundle') }
end
 
execute 'allow sudo' do
  command 'sudo sed -i \'/.*NOPASSWD: ALL/ a \vik        ALL=(ALL)      NOPASSWD: ALL\' /etc/sudoers'
end

execute 'make git colorful' do
  git config --global color.ui auto
end


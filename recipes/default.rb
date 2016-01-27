#
# Cookbook Name:: workplace
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'system'

user 'vik' do
 home "/home/vik"
 shell '/bin/bash'
 password '$1$kebqEp1T$KtW7brg4hPfNZcCmK0yk11'
end

package ['vim', 'tmux', 'epel-release']

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

execute 'allow sudo' do
	command 'sudo sed -i \'/.*NOPASSWD: ALL/ a \vik        ALL=(ALL)      NOPASSWD: ALL\' /etc/sudoers'
end




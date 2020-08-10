#
# Cookbook:: java
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

execute "update-upgrade" do
        command "sudo apt-get update && sudo apt-get upgrade -y"
        action :run
end

file '/etc/motd' do
        content node['java']['motd']
        owner 'root'
        group 'root'
        mode '0666'
end

package "#{node['java']['version']}"


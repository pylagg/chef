#
# Cookbook:: apache
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.
#

package 'apache2'

service 'apache2' do
        action [:enable,:start]

end

node['apache']["sites"].each do 
	|sitename, data|
	document_root = "/var/www/html/#{sitename}"
	
	directory document_root do
		mode "0755"    
		recursive true  
	end
	
	execute "enable-sites" do
		command "a2ensite #{sitename}"
		action :nothing
	end

	template "/etc/apache2/sites-available/#{sitename}.conf" do
	    	source "virtualhosts.erb"
	    	mode "0644"
	    	variables(
		  	:document_root => document_root,
		  	:port => data["port"],
		  	:serveradmin => data["serveradmin"],
		  	:servername => data["servername"]
	    	)
	    	notifies :run, "execute[enable-sites]"
	      	notifies :restart, "service[apache2]"
      	end

        directory "/var/www/html/#{sitename}/public_html" do
    action :create
  end


        file "/var/www/html/#{sitename}/public_html/index.html" do
                action :create
        end
      	template "/var/www/html/#{sitename}/public_html/index.html" do
      		source "#{sitename}.erb"
		notifies :run, "execute[enable-sites]"
                notifies :restart, "service[apache2]"
         end
      	directory "/var/www/html/#{sitename}/logs" do
	    	action :create
      	end

end


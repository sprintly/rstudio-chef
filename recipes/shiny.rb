if default['rstudio']['shiny']['arch'] == 'amd64'
    base_download_url = 'http://download3.rstudio.org/ubuntu-12.04/x86_64'
else
    raise Exception, "This cookbook doesn't work with i386."
end

case node["platform"].downcase
when "ubuntu", "debian"
    include_recipe "apt"

    package "r-base"

    remote_shiny_server_file = "#{base_download_url}/shiny-server-#{node['rstudio']['shiny']['version']}-#{node['rstudio']['shiny']['arch']}.deb"
    local_shiny_server_file = "/tmp/shiny-server-shiny-server-#{node['rstudio']['shiny']['version']}-#{node['rstudio']['shiny']['arch']}.deb"
    remote_file local_shiny_server_file do
        source remote_shiny_server_file 
        action :create_if_missing
        not_if { ::File.exists?('/etc/init/shiny-server.conf') }
    end

    execute "install-shiny-server" do
        command "dpkg --install #{local_shiny_server_file}"
        not_if { ::File.exists?('/etc/init/shiny-server.conf') }
    end

    r_package "shiny"
end

group "shiny"

user "shiny" do
  gid "shiny"
  action :create
end

template "/etc/init/shiny-server.conf" do
  source "etc/init/shiny-server.conf.erb"
  mode "0644"
  owner "root"
  group "root"
end

service "shiny-server" do
  provider Chef::Provider::Service::Upstart
  supports :start => true, :stop => true, :restart => true, :reload => true
  action [:enable, :start]
end

template "/etc/shiny-server/shiny-server.conf" do
  source "etc/shiny-server/shiny-server.conf.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :reload, "service[shiny-server]"
end

if node['rstudio']['shiny']['htpasswd_file'] != ''
  if Chef::Config[:solo]
    Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
  else
    users = search(:users, "groups:#{node['rstudio']['shiny']['htpasswd_group']}")

    template node['rstudio']['shiny']['htpasswd_file'] do
        source "etc/shiny-server/htpasswd.erb"
        owner "root"
        group "root"
        mode "0644"
        variables(
            :users => users
        )
        action :create
        notifies :reload, "service[nginx]"
    end
  end
end


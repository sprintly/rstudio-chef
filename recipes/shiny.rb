if node['rstudio']['shiny']['arch'] == 'amd64'
  base_download_url = 'http://download3.rstudio.org/ubuntu-14.04/x86_64'
else
  raise Exception, "This cookbook doesn't work with i386."
end

case node["platform"].downcase
when "ubuntu", "debian"
  include_recipe "apt"

  include_recipe "r::default"

  remote_shiny_server_file = "#{base_download_url}/shiny-server-#{node['rstudio']['shiny']['version']}-#{node['rstudio']['shiny']['arch']}.deb"
  local_shiny_server_file = "/tmp/shiny-server-shiny-server-#{node['rstudio']['shiny']['version']}-#{node['rstudio']['shiny']['arch']}.deb"
  remote_file local_shiny_server_file do
    source remote_shiny_server_file
    action :create_if_missing
    not_if { ::File.exists?('/etc/shiny/shiny-server.conf') }
  end

  Chef::Log.info('Installing Shiny Server via standard package resource.')
  package "shiny-server" do
      source local_shiny_server_file
      action :upgrade
  end unless platform_family?('debian')
  
  Chef::Log.info('Installing Shiny Server via dpkg resource.')
  dpkg_package "shiny-server" do
    source local_shiny_server_file
    action :upgrade
  end if platform_family?('debian')

  r_package "shiny"
end

group "shiny"

user "shiny" do
  gid "shiny"
  action :create
end

service "shiny-server" do
  action :start
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


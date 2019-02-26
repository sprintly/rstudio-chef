if debian?

    package "libssl1.0.0" do
      action :install
    end if ubuntu?

    package "psmisc" do
      action :install
    end

    remote_rstudio_server_file = "#{node['rstudio']['server']['base_download_url']}/rstudio-server-#{node['rstudio']['server']['version']}-#{node['rstudio']['server']['arch']}.deb"
    local_rstudio_server_file = "#{Chef::Config[:file_cache_path]}/rstudio-server-#{node['rstudio']['server']['version']}-#{node['rstudio']['server']['arch']}.deb"

end

if rhel? or amazon_linux?

    if _64_bit?
        arch = "x86_64"
    else
        arch = "i686"
    end

    remote_rstudio_server_file = "#{node['rstudio']['server']['base_download_url']}/rstudio-server-rhel-#{node['rstudio']['server']['version']}-#{arch}.rpm"
    local_rstudio_server_file = "#{Chef::Config[:file_cache_path]}/rstudio-server-rhel-#{node['rstudio']['server']['version']}-#{arch}.rpm"
end

Chef::Log.info('Retrieving RStudio Server file.')
remote_file local_rstudio_server_file do
    source remote_rstudio_server_file 
    action :create_if_missing
    not_if { ::File.exists?('/etc/init/shiny-server.conf') }
end

Chef::Log.info('Installing RStudio Server via dpkg resource.')
dpkg_package "rstudio-server" do
    source local_rstudio_server_file
    action :upgrade
end if platform_family?('debian')

Chef::Log.info('Installing RStudio Server via standard package resource.')
package "rstudio-server" do
    source local_rstudio_server_file
    action :upgrade
end unless platform_family?('debian')

service "rstudio-server" do
    # provider Chef::Provider::Service::Upstart
    supports :start => true, :stop => true, :restart => true
    action :start
end

# create our config files
template "/etc/rstudio/rserver.conf" do
    source "etc/rstudio/rserver.conf.erb"
    mode 0644
    owner "root"
    group "root"
    notifies :restart, "service[rstudio-server]"
end

template "/etc/rstudio/rsession.conf" do
    source "etc/rstudio/rsession.conf.erb"
    mode 0644
    owner "root"
    group "root"
    notifies :restart, "service[rstudio-server]"
end

# Set up the package repository.
case node['platform_family'].downcase
when "debian"
    include_recipe "apt"

    apt_repository "rstudio-cran" do
        uri node['rstudio']['apt']['uri']
        keyserver node['rstudio']['apt']['keyserver']
        key node['rstudio']['apt']['key']
        distribution "#{node['lsb']['codename']}/"
    end

    package "r-base" do
        action :install
    end

    package "libssl0.9.8" do
        action :install
    end

    Chef::Log.info('Retrieving RStudio Server file.')
    remote_rstudio_server_file = "#{node['rstudio']['server']['base_download_url']}/rstudio-server-#{node['rstudio']['server']['version']}-#{node['rstudio']['server']['arch']}.deb"
    local_rstudio_server_file = "#{Chef::Config[:file_cache_path]}/rstudio-server-#{node['rstudio']['server']['version']}-#{node['rstudio']['server']['arch']}.deb"
    remote_file local_rstudio_server_file do
        source remote_rstudio_server_file
        action :create_if_missing
        not_if { ::File.exists?('/etc/init/shiny-server.conf') }
    end

    Chef::Log.info('Installing RStudio Server via dpkg.')
    dpkg_package "rstudio-server" do
      source local_rstudio_server_file
      action :install
    end

when "rhel"
    Chef::Application.fatal!("Redhat based platforms are not yet supported")
end

service "rstudio-server" do
    provider Chef::Provider::Service::Upstart
    supports :start => true, :stop => true, :restart => true
    action :start
end

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

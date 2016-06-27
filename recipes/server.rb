# Set up the package repository.
case node["platform_family"].downcase
when 'debian'
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

    package "rstudio-server" do
        version #{node['rstudio']['server']['version']}
        action :install
    end

    service "rstudio-server" do
        provider Chef::Provider::Service::Upstart
        supports :start => true, :stop => true, :restart => true
        action :start
    end
when 'rhel'
    rpm = "rstudio-server-rhel-#{node['rstudio']['server']['version']}-#{node['kernel']['machine']}.rpm"

    download_url = "http://download2.rstudio.org/#{rpm}"
    rstudio_package = "#{Chef::Config[:file_cache_path]}/#{rpm}"

    remote_file rstudio_package do
        source download_url
        mode 0644
    end

    package 'rstudio-server' do
        source rstudio_package
        action :install
    end

    service "rstudio-server" do
        supports :start => true, :stop => true, :restart => true
        action :start
    end
else
    Chef::Log.info("This cookbook is not yet supported on #{node['platform']}")
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

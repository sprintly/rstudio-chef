# Set up the package repository.
case node["platform"].downcase
when "ubuntu", "debian"
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

    execute 'download-server-package' do
        command 'wget http://download2.rstudio.org/rstudio-server-0.97.336-amd64.deb -O /tmp/rstudio.deb'
        retries 20
        retry_delay 10
        creates '/tmp/rstudio.deb'
    end

    package 'gdebi'

    package "rstudio-server" do
        action :install
        source '/tmp/rstudio.deb'
        provider Chef::Provider::Package::Gdebi
    end
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

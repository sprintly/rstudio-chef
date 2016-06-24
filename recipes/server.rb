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

    package "rstudio-server" do
        action :install
    end


    service "rstudio-server" do
        # provider Chef::Provider::Service::Upstart
        supports :start => true, :stop => true, :restart => true
        action :start
    end


when "centos", "redhat", 'scientific', 'amazon', 'oracle'
  # Taken from https://github.com/marsam/cookbook-rstudio/
  if node['rstudio']['machine'] =~ /x86_64/
    package = value_for_platform(
      %w|centos redhat amazon scientific| => {
        'default' => "rstudio-server-#{node['rstudio']['version']}-x86_64.rpm"
      },
      %w|ubuntu debian| => {
        'default' => "rstudio-server-#{node['rstudio']['version']}-amd64.deb"
      }
    )
  else
    package = value_for_platform(
      %w|centos redhat amazon scientific| => {
        # 'default' => "rstudio-server-#{node['rstudio']['version']}-i686.rpm"
        'default' => "rstudio-server-rhel-0.99.902-x86_64.rpm"
      },
      %w|ubuntu debian| => {
        'default' => "rstudio-server-#{node['rstudio']['version']}-i386.deb"
      }
    )
  end

  # eg CentOS https://download2.rstudio.org/rstudio-server-rhel-0.99.902-x86_64.rpm
  download_url = "http://download2.rstudio.org/#{package}"
  rstudio_package = "#{Chef::Config[:file_cache_path]}/#{package}"

  remote_file rstudio_package do
    source download_url
    mode 0644
  end

  yum_package 'rstudio-server' do
    source rstudio_package
    action :install
  end
else
  Chef::Log.info("This cookbook is not yet supported on #{node['platform']}")
end

template "/etc/rstudio/rserver.conf" do
    source "etc/rstudio/rserver.conf.erb"
    mode 0644
    owner "root"
    group "root"
    # removed for CentOS as the service stuff is not working
    # notifies :restart, "service[rstudio-server]"
end

template "/etc/rstudio/rsession.conf" do
    source "etc/rstudio/rsession.conf.erb"
    mode 0644
    owner "root"
    group "root"
    # removed for CentOS as the service stuff is not working
    # notifies :restart, "service[rstudio-server]"
end

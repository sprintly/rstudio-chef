case node["platform"].downcase
when "ubuntu"
    version = "0.97.551"
    arch = node['kernel']['machine'] =~ /x86_64/ ? "amd64" : "i386"
end

case node["platform"].downcase
when "ubuntu"
    package "libssl0.9.8" do
        action :install
    end

    package "r-base" do
        action :install
    end

    RSTUDIO_FILE = "rstudio-server-#{version}-#{arch}.deb"
    remote_file "/tmp/#{RSTUDIO_FILE}" do
        source "http://download2.rstudio.org/#{RSTUDIO_FILE}"
    end

    execute "install_rstudio" do
        command "dpkg --install /tmp/#{RSTUDIO_FILE}"
        not_if { ::File.exists?("/usr/sbin/rstudio-server")}
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
    notifies :restart, resources(:service => "rstudio-server")
end

template "/etc/rstudio/rsession.conf" do
    source "etc/rstudio/rsession.conf.erb"
    mode 0644
    owner "root"
    group "root"
    notifies :restart, resources(:service => "rstudio-server")
end

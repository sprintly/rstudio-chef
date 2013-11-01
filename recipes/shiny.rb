case node["platform"].downcase
when "ubuntu", "debian"
    include_recipe "apt"

    package "shiny-server" do
        action :install
    end
end

service "shiny-server" do
    provider Chef::Provider::Service::Upstart
    supports :start => true, :stop => true, :restart => true, :reload => true
    action :start
end

template "/etc/shiny-server/shiny-server.conf" do
    source "etc/shiny-server/shiny-server.conf.erb"
    mode "0644"
    owner "root"
    group "root"
    notifies :reload, resources(:service => "shiny-server")
end

if node['rstudio']['shiny']['htpasswd_file'] != ''
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
        notifies :reload, resources(:service => "nginx")
    end
end

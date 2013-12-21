include_recipe "nginx"

# Only configure Nginx if the server_name attribute has been set.
if node['rstudio']['nginx']['server_name'] == ''
    raise ArgumentError, "You must specify a server_name to configure Nginx support."
else
    server_name = node['rstudio']['nginx']['server_name']
end

case node["platform"].downcase
when "ubuntu"
    template_file = "/etc/nginx/sites-available/#{server_name}"
end

if node['rstudio']['ssl']['crt_file'] != '' && node['rstudio']['ssl']['crt_file'] != ''
    use_ssl = true
else
    use_ssl = false
end

template template_file do
    source "etc/nginx/rstudio.conf.erb"
    mode 0644
    owner "root"
    group "root"
    variables({:use_ssl => use_ssl})
    notifies :reload, "service[nginx]"
end

nginx_site server_name

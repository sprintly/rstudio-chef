# CRAN
default['rstudio']['cran']['mirror'] = 'http://cran.rstudio.com/'

# APT configuration for Ubuntu or Debian installs.
case node["platform"].downcase  
when "ubuntu"
    default['rstudio']['apt']['key'] = 'E084DAB9'
    default['rstudio']['apt']['keyserver'] = 'keyserver.ubuntu.com'
    default['rstudio']['apt']['uri'] = 'http://cran.stat.ucla.edu/bin/linux/ubuntu'
when "debian"
    default['rstudio']['apt']['key'] = '381BA480'
    default['rstudio']['apt']['keyserver'] = 'subkeys.pgp.net'
    default['rstudio']['apt']['uri'] = 'http://cran.stat.ucla.edu/bin/linux/debian'
end

# You can define a simple array of packages in your role/environment/node and the 
# CRAN recipe will install them.
default['rstudio']['cran']['packages'] = []

# RStudio Server
default['rstudio']['server']['www_port'] = '8787'
default['rstudio']['server']['www_address'] = '127.0.0.1'
default['rstudio']['server']['ld_library_path'] = ''
default['rstudio']['server']['r_binary_path'] = ''
default['rstudio']['server']['user_group'] = ''

# RStudio Session
default['rstudio']['session']['timeout'] = '30'
default['rstudio']['session']['package_path'] = ''
default['rstudio']['session']['cran_repo'] = 'http://cran.case.edu/'

# Nginx
default['rstudio']['nginx']['port'] = '80'
default['rstudio']['nginx']['server_name'] = ''
default['rstudio']['nginx']['location'] = '/'
default['rstudio']['nginx']['shiny_location'] = ''
default['rstudio']['nginx']['ssl_protocols'] = 'TLSv1.2'
default['rstudio']['nginx']['ssl_session_timeout'] = '5m'
default['rstudio']['nginx']['ssl_session_cache'] = 'shared:SSL:50m'
default['rstudio']['nginx']['ssl_dhparam'] = ''  # Recommended to set
default['rstudio']['nginx']['ssl_ciphers'] = 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256'
default['rstudio']['nginx']['hsts_max_age'] = 15768000  # 15768000 seconds = 6 months

# SSL certificates
default['rstudio']['ssl']['crt_file'] = ''
default['rstudio']['ssl']['key_file'] = ''

# Shiny server
default['rstudio']['shiny']['user'] = 'shiny'
default['rstudio']['shiny']['www_port'] = '8100'
default['rstudio']['shiny']['www_address'] = '127.0.0.1'
default['rstudio']['shiny']['site_dir'] = '/var/shiny-server/www'
default['rstudio']['shiny']['log_dir'] = '/var/log/shiny-server'
default['rstudio']['shiny']['directory_index'] = 'on'

# Shiny can't be installe by APT. Don't get me started.
default['rstudio']['shiny']['version'] = '0.4.0.8'
default['rstudio']['shiny']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? "amd64" : "i386"

# Shiny server supports the users cookbook for HTTP Auth
default['rstudio']['shiny']['htpasswd_file'] = ''
default['rstudio']['shiny']['htpasswd_group'] = 'sysadmin'

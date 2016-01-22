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
default['rstudio']['server']['base_download_url'] = 'http://download2.rstudio.org'
default['rstudio']['server']['www_port'] = '8787'
default['rstudio']['server']['www_address'] = '127.0.0.1'
default['rstudio']['server']['ld_library_path'] = ''
default['rstudio']['server']['r_binary_path'] = ''
default['rstudio']['server']['user_group'] = ''
default['rstudio']['server']['version'] = '0.98.507'
default['rstudio']['server']['arch'] = node['kernel']['machine'] =~ /x86_64/ ? "amd64" : "i386"

# RStudio Session
default['rstudio']['session']['timeout'] = '30'
default['rstudio']['session']['package_path'] = ''
default['rstudio']['session']['cran_repo'] = 'http://cran.case.edu/'

# Nginx
default['rstudio']['nginx']['port'] = '80'
default['rstudio']['nginx']['server_name'] = ''
default['rstudio']['nginx']['location'] = '/'
default['rstudio']['nginx']['shiny_location'] = ''

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

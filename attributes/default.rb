# CRAN
default['rstudio']['cran']['uri'] = 'http://cran.stat.ucla.edu/bin/linux/ubuntu'
default['rstudio']['cran']['key'] = 'E084DAB9'
default['rstudio']['cran']['keyserver'] = 'keyserver.ubuntu.com'

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

# SSL certificates
default['rstudio']['ssl']['crt_file'] = ''
default['rstudio']['ssl']['key_file'] = ''

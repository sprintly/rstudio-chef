name             'rstudio'
chef_version     '>= 14'
maintainer       'Sprint.ly, Inc.'
maintainer_email 'joe@joestump.net'
license          'MIT'
description      'Installs/Configures rstudio'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.5.0'
source_url       'https://github.com/sprintly/rstudio-chef' if respond_to?(:source_url)
issues_url       'https://github.com/sprintly/rstudio-chef/issues' if respond_to?(:issues_url)

supports         'ubuntu', '>= 16.04'
supports         'debian'
supports         'centos'
supports         'amazon'

depends          "apt"
depends          "chef-sugar"
depends          "nginx"
depends          "r", '~> 0.4.0'
depends          "yum-epel"

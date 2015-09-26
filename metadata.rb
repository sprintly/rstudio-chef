name             'rstudio'
maintainer       'Sprint.ly, Inc.'
maintainer_email 'joe@joestump.net'
license          'All rights reserved'
description      'Installs/Configures rstudio'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.0'
source_url       'https://github.com/sprintly/rstudio-chef' if respond_to?(:source_url)
issues_url       'https://github.com/sprintly/rstudio-chef/issues' if respond_to?(:issues_url)
supports         'ubuntu', '>= 12.04'
supports         'redhat'
supports         'centos'
supports         'amazon'

depends "apt"
depends "nginx"
depends "r"
depends "chef-sugar"
depends "yum-epel"
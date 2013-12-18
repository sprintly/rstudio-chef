name             'rstudio'
maintainer       'Sprint.ly, Inc.'
maintainer_email 'joe@joestump.net'
license          'All rights reserved'
description      'Installs/Configures rstudio'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.0'

depends "apt"
depends "nginx"
depends "r"

name             'rstudio'
maintainer       'Sprint.ly, Inc.'
maintainer_email 'joe@joestump.net'
license          'BSD'
description      'Installs/Configures rstudio'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.1'

depends "apt"
depends "nginx"
depends "r"

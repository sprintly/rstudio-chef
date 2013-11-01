rstudio CHANGELOG
=================

0.1.0
-----
- Initial release of rstudio

0.2.0
-----
- Added [Shiny Server](http://www.rstudio.com/shiny/server/) support
- Added tentative support for Debian (Joe Stump)
- Updated the APT installation to use the official APT repositories for Ubuntu and Debian
- Updated the Nginx configuration to support serving both RStudio and Shiny from the same server
- Now depends on the [r](https://github.com/stevendanna/cookbook-r/) cookbook.
- Fixed support for `node['rstudio']['cran']['packages']` using `r_package` LWRP from the `r` cookbook.

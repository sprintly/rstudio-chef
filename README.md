# Description

This cookbook will install RStudio Server along with some extras that will configure various usages. In addition to installing the server, it can optionally set up CRAN's distribution-specific repositories, configure various Nginx options (SSL, proxy, and alternate locations), as well as an alternative to the default PAM configuration that doe *not* rely on a local user account.

* `rstudio::server` will download and configure the RServer packages.
* `rstudio::pam` will install the PAM [pam_pwdfile](https://github.com/tiwe-de/libpam-pwdfile) module. This module allows you to define username/password combinations using the `mkpasswd` utility. This allows you to give access to RStudio Server *without* creating accounts on the server itself.
* `rstudio::cran` will install R packages listed in `node['rstudio']['cran']['packages']` using `r_package` from the [r](https://github.com/stevendanna/cookbook-r/) cookbook.
* `rstudio::nginx` will configure an Nginx site for RStudio. It offers the ability to proxy via a separate URL as well as basic SSL support. When coupled with `rstudio::pam`, you can give remote access to RStudio via Nginx over SSL to people *without* direct access to the server via SSH.
* `rstudio::shiny` will install and configure the [Shiny Server](http://www.rstudio.com/shiny/server/) packages.

# Requirements

## Cookbooks

The following Chef cookbooks are required:

* [r](https://github.com/stevendanna/cookbook-r/)
* [apt](https://github.com/opscode-cookbooks/apt)
* [nginx](https://github.com/opscode-cookbooks/nginx)
* [users](https://github.com/opscode-cookbooks/users)

## Platform

The following platforms are supported:

* Ubuntu
* Debian

By default RStudio and its related packages are installed via APT on Debian/Ubuntu. You can modify the default repository using the following attribributes.

* `node['rstudio']['apt']['uri']` - The URI of the APT repository. Defaults to `http://cran.stat.ucla.edu/bin/linux/ubuntu` on Ubuntu and `'http://cran.stat.ucla.edu/bin/linux/debian` on Debian.
* `node['rstudio']['apt']['key']` - The key for the distribution. Defaults to `E084DAB9` on Ubunto and `381BA480` on Debian.
* `node['rstudio']['apt']['keyserver']` - The key server for the repository. Defaults to `keyserver.ubuntu.com` on Ubuntu and `subkeys.pgp.net` on Debian.

# Attributes

## rstudio::server

* `node['rstudio']['server']['www_port']` - The port that RStudio Server binds to. Defaults to `8787`.
* `node['rstudio']['server']['www_address']` - The address that RStudio Server binds to. Defaults to `127.0.0.1`
* `node['rstudio']['server']['ld_library_path']` - The LD library path.
* `node['rstudio']['server']['r_binary_path']` - The path to R.
* `node['rstudio']['server']['user_group']` - User groups you'd like to restrict to. **NOTE:** The `rstudio::pam` recipe will likely ignore and/or conflict with this setting if used.
* `node['rstudio']['session']['timeout']` - The session timeout in minutes. Defaults to `30`.
* `node['rstudio']['session']['package_path']` - The R package path.
* `node['rstudio']['session']['cran_repo']` - The CRAN repository to use. Defaults to `http://cran.case.edu/`.

See also: [RStudio Server: Configuring the Server](http://www.rstudio.com/ide/docs/server/configuration)

## rstudio::pam

The `rstudio::pam` recipe works on top of the [users](https://github.com/opscode-cookbooks/users) cookbook, which uses data bags. In your various `users` data bags, put the following stanza in to create an RStudio account for them:

```
  "rstudio": {
    "passwd": "WQtdiGghp/GSU"
  }
```

You can create a password with the `mkpasswd` utility.

## rstudio::cran

* `node['rstudio']['cran']['mirror']` - The CRAN distribution repository. Defaults to `http://cran.rstudio.com/`. This value is used to set `r-cran-repos` in `rsession.conf`.
* `node['rstudio']['cran']['packages'] - A list of CRAN packages to install using the `r_package` LWRP from the [r](https://github.com/stevendanna/cookbook-r/) cookbook.

## rstudio::nginx

* `node['rstudio']['nginx']['port']` - The port to listen on. Defaults to `80`. If you specify a `node['rstudio']['ssl']['crt_file']` and `node['rstudio']['ssl']['key_file']`, this will be overridden to use `443`.
* `node['rstudio']['nginx']['server_name']` - You **must** set a server name to utilize the Nginx recipe.
* `node['rstudio']['nginx']['location']` - The location you'd like to proxy RStudio requests from. Defaults to `/`. You could change this to `/rstudio/` to change the location of RStudio.
* `node['rstudio']['ssl']['crt_file']` - An SSL certificate file to use. This enables SSL.
* `node['rstudio']['ssl']['key_file']` - Your SSL certificate's private key file.

**NOTE:** The Nginx recipe does *not* use HTTP-Auth. This is because RStudio will *only* authenticate via PAM. There is no way to turn off authentication either.

## rstudio::shiny

Installs and configures [Shiny Server](http://www.rstudio.com/shiny/server/). For more information see the documentation on [configuration settings](http://rstudio.github.io/shiny-server/latest/#configuration-settings).

* `node['rstudio']['shiny']['user']` - The user that Shiny will run as. Defaults to `shiny`.
* `node['rstudio']['shiny']['www_port']` - The port that Shiny will listen on. Defaults to `8100`.
* `node['rstudio']['shiny']['www_address']` - The address that Shiny will listen on. Defaults to `127.0.0.1`.
* `node['rstudio']['shiny']['site_dir']` - The server directory. Defaults to `/srv/shiny-server`.
* `node['rstudio']['shiny']['log_dir']` - Where the log files will reside. Defaults to `/var/log/shiny-server`.
* `node['rstudio']['shiny']['directory_index']` - Whether or not to turn on directory indexing. Defaults to `on`.
* `node['rstudio']['shiny']['htpasswd_file']` - Path to the username/password file to use for [authentication](http://nginx.org/en/docs/http/ngx_http_auth_basic_module.html). Defaults to `/etc/shiny-server/htpasswd`.
* `node['rstudio']['shiny']['htpasswd_group']` - The group to use for `node['rstudio']['shiny']['htpasswd_file']`, which requires use of the [users](https://github.com/opscode-cookbooks/users) cookbook. Defaults to `sysadmin`.

# Usage

The only thing you need to watch out for is that `rstudio::cran` is listed before `rstudio::server` if you'd like to use CRAN's packages for `r-base` and other related R packages.

```
  "run_list": [
    "recipe[rstudio::cran]",
    "recipe[rstudio::server]",
    "recipe[rstudio::nginx]",
    "recipe[rstudio::pam]"
  ]
```

This is an example configuration for a role file that sets up Nginx with SSL and modifies the default path:

```
  "default_attributes": {
    "rstudio": {
      "nginx": {
        "server_name": "data.example.com",
        "location": "/rstudio/"
      },
      "ssl": {
        "crt_file": "/path/to/example.crt",
        "key_file": "/path/to/example.key"
      }
    },
  }
```

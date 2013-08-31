# Description

This cookbook will install RStudio Server along with some extras that will configure various usages. In addition to installing the server, it can optionally set up CRAN's distribution-specific repositories, configure various Nginx options (SSL, proxy, and alternate locations), as well as an alternative to the default PAM configuration that doe *not* rely on a local user account.

* `rstudio::server` will download and configure the RServer packages.
* `rstudio::pam` will install the PAM [pam_pwdfile](https://github.com/tiwe-de/libpam-pwdfile) module. This module allows you to define username/password combinations using the `mkpasswd` utility. This allows you to give access to RStudio Server *without* creating accounts on the server itself.
* `rstudio::cran` will configure CRAN's package repositories for your specific platform. **NOTE:** This will *not* install CRAN packages. These are only the basic R and a few core packages that are maintained by CRAN. This is useful if you'd rather use CRAN's packages over your distribution's R packages.
* `rstudio::nginx` will configure an Nginx site for RStudio. It offers the ability to proxy via a separate URL as well as basic SSL support. When coupled with `rstudio::pam`, you can give remote access to RStudio via Nginx over SSL to people *without* direct access to the server via SSH.

# Requirements

## Cookbooks

The following Chef cookbooks are required:

* apt
* nginx

## Platform

The following platforms have been tested:

* Ubuntu 12.04 LTS (Precise)

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
    "passwd": "WaaePVGwVzClU"
  }
```

You can create a password with the `mkpasswd` utility.

## rstudio::cran

* `node['rstudio']['cran']['uri']` - The CRAN distribution repository. Defaults to `http://cran.stat.ucla.edu/bin/linux/ubuntu`.
* `node['rstudio']['cran']['key']` - The key for the distribution. Defaults to `E084DAB9`.
* `node['rstudio']['cran']['keyserver']` - The key server for the repository. Defaults to `keyserver.ubuntu.com`

## rstudio::nginx

* `node['rstudio']['nginx']['port']` - The port to listen on. Defaults to `80`. If you specify a `node['rstudio']['ssl']['crt_file']` and `node['rstudio']['ssl']['key_file']`, this will be overridden to use `443`.
* `node['rstudio']['nginx']['server_name']` - You **must** set a server name to utilize the Nginx recipe.
* `node['rstudio']['nginx']['location']` - The location you'd like to proxy RStudio requests from. Defaults to `/`. You could change this to `/rstudio/` to change the location of RStudio.
* `node['rstudio']['ssl']['crt_file']` - An SSL certificate file to use. This enables SSL.
* `node['rstudio']['ssl']['key_file']` - Your SSL certificate's private key file.

**NOTE:** The Nginx recipe does *not* use HTTP-Auth. This is because RStudio will *only* authenticate via PAM. There is no way to turn off authentication either.

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

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile for rstudio-chef

Vagrant.configure("2") do |config|

  # Name the box for Vagrant
  config.vm.define :RStudio

  config.vm.provider "virtualbox" do |rstudio|
     rstudio.name = "RStudio"
  end

  config.vm.hostname = "rstudio-server"

  config.omnibus.chef_version = "11.6.0"

  # Use the provisionerless ubuntu. Omnibus will install the right version of Chef.
  config.vm.box = "opscode-ubuntu-12.04"
  config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"

  config.vm.network :private_network, ip: "33.33.33.11"

  # Forward the default port for RStudio
  config.vm.network :forwarded_port, guest: 8787, host: 8787

  config.ssh.max_tries = 40
  config.ssh.timeout   = 120

  # Enabling the Berkshelf plugin. To enable this globally, add this configuration
  # option to your ~/.vagrant.d/Vagrantfile file
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
    }

    chef.run_list = [
        "recipe[chef-solo-search]",
        "recipe[apt]",
        "recipe[rstudio::default]",
        "recipe[rstudio::cran]", # rstudio::cran must come before rstudio::server
        "recipe[rstudio::server]",
        "recipe[rstudio::pam]"
    ]
  end
end

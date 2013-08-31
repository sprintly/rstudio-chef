case node["platform"].downcase
when "ubuntu"
    include_recipe "apt"

    apt_repository "cran" do
        uri node['rstudio']['cran']['uri']
        keyserver node['rstudio']['cran']['keyserver']
        key node['rstudio']['cran']['key']
        distribution "#{node['lsb']['codename']}/"
    end
end

node['rstudio']['cran']['packages'].each do |cran_package| 
    package cran_package do
        action :install
    end
end

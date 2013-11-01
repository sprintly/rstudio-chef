include_recipe "r"

node['rstudio']['cran']['packages'].each do |cran_package| 
    r_package cran_package do
        action :install
    end
end

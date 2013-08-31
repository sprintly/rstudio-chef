#!/usr/bin/env ruby

site :opscode

cookbook 'apt'
cookbook 'nginx'

# Solely for the Vagrantfile to be able to use chef-solo
# + data bags
cookbook 'chef-solo-search',
  :git => 'https://github.com/edelight/chef-solo-search/',
  :ref => '1f79c1d86e85aa3a2b01e15f90755cf60eb66a4f'

metadata


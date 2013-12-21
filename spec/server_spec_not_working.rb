require 'spec_helper'

describe 'rstudio::server' do
  let(:chef_run) do
#    ChefSpec::Runner.new do |node|
#      node.set['lsb']['codename'] = 'ubuntu'
#    end.converge(described_recipe)
    ChefSpec::Runner.new
  end

  before(:each) do 
    Fauxhai.mock(platform: 'ubuntu', version: '12.04') do |node|
      node['platform'] = 'ubuntu'
    end
  end

  it('should install r-base') do
    chef_run.converge(described_recipe)
    expect(chef_run).to install_package('r-base')
  end

  it('should install rstudio-server') do
    chef_run.converge(described_recipe)
    expect(chef_run).to install_package('rstudio-server')
  end
end

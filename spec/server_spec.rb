require 'spec_helper'

describe 'rstudio::server' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
    runner.converge(described_recipe)
  end

  it('should install r-base') do
    expect(chef_run).to install_package('r-base')
  end

  it('should install rstudio-server') do
    expect(chef_run).to install_package('rstudio-server')
  end
end

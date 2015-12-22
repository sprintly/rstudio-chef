require 'spec_helper'

describe 'rstudio::pam' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new platform: 'ubuntu', version: '12.04' do |node|
      node.set['rstudio']['nginx']['server_name'] = 'test.example.com'
    end.converge(described_recipe)
  end

  it('includes rstudio::server') do 
    expect(chef_run).to include_recipe('rstudio::server')
  end

  it('install libpam-pwdfile') do
    expect(chef_run).to install_package('libpam-pwdfile')
  end
end

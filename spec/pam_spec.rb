require 'spec_helper'

describe 'rstudio::pam' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
    runner.node.set['rstudio']['nginx']['server_name'] = 'test.example.com'
    runner.converge(described_recipe)
  end

  it('install libpam-pwdfile') do
    expect(chef_run).to install_package('libpam-pwdfile')
  end
end

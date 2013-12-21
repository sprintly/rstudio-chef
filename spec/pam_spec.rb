require 'spec_helper'

describe 'rstudio::pam' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  before(:each) do
#    stub_data_bag('users').and_return([
#      {
#        'id' => 'jstump'
#        'groups' => ['sysadmin', 'rstudio'],
#        'rstudio' => {
#          'passwd' => 'SzaeXVLlxxClU'
#        }
#      }
#    ])
    stub_search(:users, 'groups:rstudio').and_return([
      { id: 'joestump' }
    ])
  end

  it('install libpam-pwdfile') do
    expect(chef_run).to install_package('libpam-pwdfile')
  end

  it('creates /etc/rstudio/passwd') do
    expect(chef_run).to render_file('/etc/rstudio/passwd')
  end
end

require 'chefspec'
require 'chefspec/berkshelf'

describe 'rstudio::server' do
  platform 'ubuntu', '16.04'

  context 'basic package install' do
    it {is_expected.to install_package(['rstudio-server', 'libssl1.0.0', 'psmisc'])}
  end
end

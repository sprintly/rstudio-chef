require 'chefspec'
require 'chefspec/berkshelf'

describe 'rstudio::cran' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
    runner.converge(described_recipe)
  end
end

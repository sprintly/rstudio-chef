require 'spec_helper'

describe 'rstudio::cran' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
    runner.converge(described_recipe)
  end
end

require 'spec_helper'

describe 'rstudio::cran' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['rstudio']['cran']['packages'] = ['aadsf']
    end.converge(described_recipe)
  end
end

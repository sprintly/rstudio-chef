require 'spec_helper'

describe 'rstudio::cran' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['rstudio']['cran']['packages'] = ['aadsf']
    end.converge(described_recipe)
  end

  it('should include the r cookbook') do
    expect(chef_run).to include_recipe('r')
  end
end

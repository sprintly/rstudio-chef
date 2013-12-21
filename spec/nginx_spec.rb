require 'spec_helper'

describe 'rstudio::nginx' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
    runner.node.set['rstudio']['nginx']['server_name'] = 'test.example.com'
    runner.converge(described_recipe)
  end

  it 'should create a knife.rb' do
    template_file = '/etc/nginx/sites-available/test.example.com'
    expect(chef_run).to render_file(template_file)
  end
end

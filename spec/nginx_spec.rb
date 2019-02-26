require 'chefspec'
require 'chefspec/berkshelf'

describe 'rstudio::nginx' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
    runner.node.normal['rstudio']['nginx']['server_name'] = 'test.example.com'
    runner.converge(described_recipe)
  end

  before(:each) do 
    stub_command('which nginx').and_return(true)
  end

  it 'should create a template file' do
    template_file = '/etc/nginx/sites-available/test.example.com'
    expect(chef_run).to render_file(template_file)
  end
end

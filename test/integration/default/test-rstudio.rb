describe port(8787) do
  it { should be_listening }
  its('addresses') { should include '127.0.0.1' }
end

# http://inspec.io/docs/reference/resources/service/
describe service('rstudio-server') do
  it { should be_running }
end
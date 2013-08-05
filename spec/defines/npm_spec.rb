require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'nodejs::npm' do

  let(:title) { 'nodejs::npm' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) do
    { 
      :ipaddress => '10.42.42.42', 
      :npm_local_dir => '/opt/razor',
    }
  end
  describe 'Test basic npm package installation' do
    it { should contain_exec('npm_install_nodejs::npm').with_command('npm install  nodejs::npm') }
  end

  describe 'Test npm package installation with name and version' do
    let(:params) do
      {
        :pkg_name => 'sample1',
        :version  => '42.42.42',
      }
    end
    it { should contain_exec('npm_install_sample1').with_command('npm install  sample1@42.42.42') }
    it { should contain_exec('npm_install_sample1').with_cwd('/opt/razor') }
  end

  describe 'Test npm package installation with name and path' do
    let(:params) do
      {
        :pkg_name   => 'sample2',
        :install_dir=> '/some/dir',
      }
    end
    it { should contain_exec('npm_install_sample2').with_command('npm install  sample2') }
    it { should contain_exec('npm_install_sample2').with_cwd('/some/dir') }
  end

  describe 'Test npm package removal' do
    let(:params) do
      {
        :pkg_name => 'sample3',
        :ensure   => 'absent',
      }
    end
    it { should contain_exec('npm_remove_sample3').with_command('npm remove sample3') }
    it { should contain_exec('npm_remove_sample3').with_onlyif('npm list -p -l | grep \'/opt/razor/node_modules/sample3\'') }
  end
end

require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'nodejs' do

  let(:title) { 'nodejs' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test minimal installation' do
    it { should contain_package('nodejs').with_ensure('present').with_noop(nil) }
    it { should_not contain_package('build-essential').with_ensure('present').with_noop(nil) }
    it { should_not contain_package('python').with_ensure('installed').with_noop(nil) }
    it { should_not contain_package('git').with_ensure('installed').with_noop(nil) }
  end

  describe 'Test installation on debian squeeze' do
    let :facts do
      {
        :operatingsystem => 'Debian',
        :lsbdistcodename => 'squeeze',
      }
    end

    it { should_not contain_package('nodejs').with_ensure('present') }
    it { should contain_package('build-essential').with_ensure('installed').with_noop(nil) }
    it { should contain_package('python').with_ensure('installed').with_noop(nil) }
    it { should contain_package('git').with_ensure('installed').with_noop(nil) }
    it { should contain_exec('build nodejs') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('nodejs').with_ensure('1.0.42') }
  end

  describe 'Test deploying with proxy' do
    let :facts do
      {
        :operatingsystem => 'Ubuntu',
        :lsbdistcodename => 'edgy',
      }
    end

    let :params do
      { :npm_proxy => 'http://proxy.puppetlabs.lan:80/' }
    end

    it { should contain_package('npm').with_name('npm') }
    it { should contain_exec('npm_proxy').with({
      'command' => 'npm config set proxy http://proxy.puppetlabs.lan:80/',
      'require' => 'Package[npm]',
    }) }
    it { should_not contain_package('nodejs-stable-release') }
  end

  describe 'Test deploying with proxy on debian squeeze' do
    let :facts do
      {
        :operatingsystem => 'Debian',
        :lsbdistcodename => 'squeeze',
      }
    end

    let :params do
      { :npm_proxy => 'http://proxy.puppetlabs.lan:80/' }
    end

    it { should contain_exec('npm_proxy').with({
      'command' => 'npm config set proxy http://proxy.puppetlabs.lan:80/',
      'require' => 'Exec[build nodejs]',
    }) }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true } }
    it 'should remove Package[nodejs]' do should contain_package('nodejs').with_ensure('absent') end 
  end

  describe 'Test noops mode' do
    let(:params) { {:noops => true} }
    it { should contain_package('nodejs').with_noop('true') }
  end

  describe 'Test noops mode on debian squeeze' do
    let(:params) { {:noops => true} }
    let :facts do
      {
        :operatingsystem => 'Debian',
        :lsbdistcodename => 'squeeze',
      }
    end

    it { should contain_package('build-essential').with_noop('true') }
    it { should contain_package('python').with_noop('true') }
    it { should contain_package('git').with_noop('true') }
    it { should contain_exec('build nodejs') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "nodejs::spec" } }
  end

end

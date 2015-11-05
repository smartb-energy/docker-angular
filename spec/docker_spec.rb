# Note: although we require 'docker' here, the gem that satisfies this requirement
# is the 'docker-api' gem (see this project's Gemfile)
require 'docker'
require 'serverspec'

set :backend, :exec

describe "Dockerfile" do
  before(:all) do
    image = Docker::Image.build_from_dir('.') do |v|
      if (log = JSON.parse(v)) && log.has_key?("stream")
        $stdout.puts log["stream"]
      end
    end

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image.id
  end

  describe file ('/home/root/prepare_image.sh') do
    its(:content) { should match /set -e/ }
  end

  describe package('nodejs-legacy') do
    it { should be_installed }
  end

  describe package('npm') do
    it { should be_installed }
  end

  describe package('git') do
    it { should be_installed }
  end

  describe command('npm list -g bower') do
    its(:stdout) { should match /bower/ }
  end

  describe command('npm list -g grunt-cli') do
    its(:stdout) { should match /grunt-cli/ }
  end

  describe package('nginx') do
    it { should be_installed }
  end

  describe package('ruby-dev') do
    it { should be_installed }
  end

  describe package('sass') do
    it { should be_installed.by('gem') }
  end
end

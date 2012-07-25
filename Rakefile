require 'rubygems'
require 'bundler/setup'
require 'xcoder'
require 'restkit/rake'
require 'ruby-debug'

RestKit::Rake::ServerTask.new do |t|
  t.port = 4567
  t.pid_file = 'OTPClientTests/Server/server.pid'
  t.rackup_file = 'OTPClientTests/Server/server.ru'
  t.log_file = 'OTPClientTests/Server/server.log'

  t.adapter(:thin) do |thin|
    thin.config_file = 'OTPClientTests/Server/thin.yml'
  end
end

namespace :test do
  task :kill_simulator do
    system(%q{killall -m -KILL "iPhone Simulator"})
  end
  
  desc "Run the application tests for iOS"
  task :application => :kill_simulator do
    config = Xcode.project(:OTPClient).target(:OTPClientTests).config(:Debug)
    builder = config.builder
    build_dir = File.dirname(config.target.project.path) + '/Build'
    builder.symroot = build_dir + '/Products'
    builder.objroot = build_dir
    builder.test(:sdk => 'iphonesimulator')
  end
  
  desc "Run all OTPClient tests"
  task :all => ['test:application']
end

desc 'Run all the GateGuru tests'
task :test => "test:all"

task :default => ["server:autostart", "test:all", "server:autostop"]
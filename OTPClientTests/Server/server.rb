#!/usr/bin/env ruby
# OTPClient Test Server
# Provides a simple HTTP server for retrieving payloads stored in
# the Fixtures/ subdirectory. This allows us to unit test our object loaders
# without hitting Github

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'json'

configure do
  enable :logging, :dump_errors
  set :public_dir, Proc.new { File.expand_path(File.join(root, '../Fixtures')) }
end

def render_fixture(filename)
  send_file File.join(settings.public_folder, filename)
end

get '/ws/plan' do
  content_type 'application/json'
  render_fixture('response.json')
end
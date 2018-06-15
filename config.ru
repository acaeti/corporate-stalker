require 'rubygems'
require 'bundler/setup'
require File.expand_path '../corporate-stalker.rb', __FILE__
run Sinatra::Application

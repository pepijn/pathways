require 'bundler'
Bundler.require

require 'open-uri'
require 'json'

require './app'
run Sinatra::Application

require 'bundler'
Bundler.require

require 'open-uri'
require 'json'

require './service/app'
run Sinatra::Application

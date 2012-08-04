require 'bundler'
Bundler.require

require 'open-uri'

require './service/app'
run Sinatra::Application

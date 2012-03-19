require 'rubygems'
require 'bundler'

Bundler.setup

require './comida'

use Rack::ShowExceptions

map '/' do
  run Comida::ComidaWebApp
end

map '/api' do
  run Comida::ComidaApi
end
  
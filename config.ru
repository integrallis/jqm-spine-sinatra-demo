require 'rubygems'
require 'bundler'

Bundler.require(:default)

require './comida'

use Rack::ShowExceptions

map '/' do
  run Comida::ComidaWebApp
end

map '/api' do
  run Comida::ComidaApi
end

$stdout.sync = true
  
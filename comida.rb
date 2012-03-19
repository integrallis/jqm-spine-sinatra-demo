require 'sinatra/base'
require 'mustache/sinatra'
require 'json'

module Comida
  #
  #
  #
  class ComidaWebApp < Sinatra::Base
    register Mustache::Sinatra
    require './views/layout'

    set :mustache, {
       :namespace => Comida::ComidaWebApp,
       :views     => "#{File.dirname(__FILE__)}/views",
       :templates => "#{File.dirname(__FILE__)}/templates"
    }

    get '/' do
      @title = "Mustache + Sinatra = Wonder"
      mustache :index
    end

    get '/other' do
      mustache :other
    end

    get '/nolayout' do
      content_type 'text/plain'
      mustache :nolayout, :layout => false
    end
  
    # start the server if ruby file executed directly
    run! if app_file == $0
  end
  
  #
  #
  #
  class ComidaApi < Sinatra::Base
    get '/search.json' do
      content_type :json
      { :key1 => 'value1', :key2 => 'value2' }.to_json
    end
  end
end

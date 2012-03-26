require 'sinatra/base'
require 'sinatra/reloader'
require 'mustache/sinatra'
require 'json'
require 'sinatra/activerecord'
require 'barista'

# Application 
require "#{File.dirname(__FILE__)}/models"

Barista.root = File.join(File.dirname(__FILE__), 'coffeescripts')

module Comida
  #
  # The Web App
  #
  class ComidaWebApp < Sinatra::Base
    register Mustache::Sinatra
    register Barista::Integration::Sinatra
    
    require './views/layout'

    set :mustache, {
       :namespace => Comida::ComidaWebApp,
       :views     => "#{File.dirname(__FILE__)}/views",
       :templates => "#{File.dirname(__FILE__)}/templates"
    }

    get '/' do
      mustache :search
    end

    get '/menus' do
      mustache :menus
    end
  
    # start the server if ruby file executed directly
    run! if app_file == $0
  end
  
  #
  # The API
  #
  class ComidaApi < Sinatra::Base
    
    #
    # Search for restaurants based on location
    #
    get '/search.json' do
      query = params[:q]
      latitude = params[:latitude]
      longitude = params[:longitude]
      distance = params[:distance]
      
      restaurants = []
      
      Restaurant.near(query.empty? ? [latitude.to_f, longitude.to_f] : query, distance || 10).each do |r| 
        restaurants << { :id => r.id, :name => r.name } 
      end
      
      response = {}
      response[:restaurants] = restaurants
  
      content_type :json
      response.to_json
    end
    
    #
    # Get a Combined Menu for selected restaurants (get a hash of categories, values are arrays)
    # I apologize to humanity for this atrocity!!!!! 
    #
    get '/menus.json' do
      restaurants_ids = []
      params.each_pair do |n,v|  
        restaurants_ids << n.split('_').last.to_i if n =~ /restaurant_(.*)/ && v=='on'
      end
      
      categorized = MenuItem.where(:restaurant_id => restaurants_ids).each_with_object({}) do |item, h| 
        (h[item.category.to_sym] ||= []) << item 
      end
      
      response = {}
      response[:menu] = {}
      response[:menu][:categories] = []
      
      categorized.each_pair do |category, items|
        items_formatted = []
        items.each do |i| 
          items_formatted << { :pid => i.id, :title => i.name, :description => i.description, :image => i.image, :price => i.price }
        end
        response[:menu][:categories] << { :name => category, :items => items_formatted }
      end

      content_type :json
      response.to_json
    end
    
    #
    # Submit Your Order
    #
    
    # post '/order/?' do 
    #   jdata = params[:data]
    #   for_json = JSON.parse(jdata)
    # end
    # response = RestClient.post 'http://localhost:4567/solve', {:data => jdata}, {:content_type => :json, :accept => :json}
    
  end
end

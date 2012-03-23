require 'sinatra'
require 'sinatra/activerecord'
require 'geocoder'
require 'uri'

class Restaurant < ActiveRecord::Base
  extend Geocoder::Model::ActiveRecord
  
  has_many :menu_items
  
  geocoded_by :full_address
  after_validation :geocode
  
  validates :address_line_1, :length => { :maximum => 255 }
  validates :address_line_2, :length => { :maximum => 255 }, :allow_nil => true, :allow_blank => true
	validates :city, :length => { :maximum => 255 }
	validates :zip, :length => { :maximum => 10 }, :format => { :with => /\d{5}(-\d{4})?/ }
	validates :state, :length => { :is => 2 }

  def full_address
    %[#{address_line_1} #{",#{address_line_2}" unless address_line_2.blank? }, #{city}, #{state} #{zip}]
  end
end

class MenuItem < ActiveRecord::Base
  belongs_to :restaurant
end


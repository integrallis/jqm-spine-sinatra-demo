require 'yaml'
require "#{File.dirname(__FILE__)}/models"

yml = YAML.load_file 'seeds.yml'
yml.each_pair do |name, info| 
   restaurant = Restaurant.create(
    :name => name, 
    :address_line_1 => info["address_line_1"],
    :city => info["city"],
    :zip => info["zip"],
    :state => info["state"],
    :price_low => info["price_low"],
    :price_high => info["price_high"],
    :category => info["category"],
    :phone => info["phone"]
  )
  
  info["menu_items"].each do |menu_item|
    menu_item = MenuItem.create(
      :name => menu_item["title"],
      :description => menu_item["description"],
      :image => menu_item["image"],
      :price => menu_item["price"],
      :category => menu_item["category"]
    )
    restaurant.menu_items << menu_item
  end
  
  restaurant.save
end


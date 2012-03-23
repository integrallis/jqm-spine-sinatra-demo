class CreateRestaurants < ActiveRecord::Migration
  def self.up
    create_table :restaurants do |t|
      t.string :name
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.decimal :price_low
      t.decimal :price_high
      t.string :category
      t.float :latitude
      t.float :longitude
    end
    add_index :restaurants, :name
  end

  def self.down
    drop_table :restaurants
  end
end

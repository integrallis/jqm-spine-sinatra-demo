class CreateMenuItems < ActiveRecord::Migration
  def self.up
    create_table :menu_items do |t|
      t.string :name
      t.string :description
      t.string :image
      t.decimal :price
      t.string :category
      t.integer :restaurant_id
    end
    add_index :menu_items, :name
    add_index :menu_items, :category
  end

  def self.down
    drop_table :menu_items
  end
end
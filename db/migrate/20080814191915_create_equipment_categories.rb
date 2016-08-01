class CreateEquipmentCategories < ActiveRecord::Migration
  def self.up
    create_table :equipment_categories do |t|
      t.integer :display_order, :default => 0
      t.boolean :is_muliselect, :default => false
      t.boolean :multi_use, :default => false
      t.string :name
      t.string :description
      t.string :slug, :length => 64
    end
    
    create_table :equipment_category_aircraft_types do |t|
      t.integer :equipment_category_id, :null => false
      t.integer :aircraft_type_id, :null => false
    end
    
  end

  def self.down
    drop_table :equipment_categories
  end
end

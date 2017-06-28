class CreateBottles < ActiveRecord::Migration[5.1]
  def change
    create_table :bottles do |t|
      t.string :wine_type
      t.integer :price
      t.integer :year
      t.integer :owner_id
      t.integer :winery_id
    end
  end
end

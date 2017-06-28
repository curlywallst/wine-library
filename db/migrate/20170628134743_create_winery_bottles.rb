class CreateWineryBottles < ActiveRecord::Migration[5.1]
  def change
    create_table :winery_bottles do |t|
      t.integer :winery_id
      t.integer :bottle_id
    end
  end
end

class CreateWineries < ActiveRecord::Migration[5.1]
  def change
    create_table :wineries do |t|
      t.string :name
      t.string :location
    end
  end
end

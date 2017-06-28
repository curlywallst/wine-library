class CreateOwners < ActiveRecord::Migration[5.1]
  def change
    create_table :owners do |t|
      t.string :name
      t.string :password_digest
    end
  end
end

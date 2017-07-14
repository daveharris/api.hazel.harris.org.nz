class CreateFeedings < ActiveRecord::Migration[5.1]
  def change
    create_table :feedings do |t|
      t.datetime :at
      t.string   :type
      t.integer  :amount # Bottle
      t.string   :quantity # Solid
      t.string   :description

      t.timestamps
    end
    add_index :feedings, :type
    add_index :feedings, [:at, :type], unique: true
  end
end

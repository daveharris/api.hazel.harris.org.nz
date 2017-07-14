class CreateMedications < ActiveRecord::Migration[5.1]
  def change
    create_table :medications do |t|
      t.datetime :at
      t.string   :medication
      t.float    :amount
      t.string   :quantity
      t.string   :notes

      t.timestamps
    end
    add_index :medications, :medication
    add_index :medications, [:at, :medication], unique: true
  end
end

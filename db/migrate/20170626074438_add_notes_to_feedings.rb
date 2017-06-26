class AddNotesToFeedings < ActiveRecord::Migration[5.1]
  def change
    add_column :feedings, :notes,    :string
    add_column :feedings, :duration, :integer
  end
end

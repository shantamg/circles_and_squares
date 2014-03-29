class AddBasedOnToDrawings < ActiveRecord::Migration
  def change
    add_column :drawings, :based_on, :string
  end
end

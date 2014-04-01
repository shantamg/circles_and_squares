class AddImgToDrawings < ActiveRecord::Migration
  def change
    add_column :drawings, :img, :boolean, default: false, null: false
  end
end

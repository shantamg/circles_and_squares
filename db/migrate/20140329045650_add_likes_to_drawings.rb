class AddLikesToDrawings < ActiveRecord::Migration
  def change
    add_column :drawings, :likes, :integer, default: 0
  end
end

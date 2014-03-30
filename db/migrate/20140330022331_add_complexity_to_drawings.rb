class AddComplexityToDrawings < ActiveRecord::Migration
  def change
    add_column :drawings, :complexity, :integer
  end
end

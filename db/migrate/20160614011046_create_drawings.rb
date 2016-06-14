class CreateDrawings < ActiveRecord::Migration[5.0]
  def change
    create_table :drawings do |t|
      t.text :sprites_json
      t.string :name
      t.integer :salt
      t.integer :likes
      t.string :based_on
      t.integer :complexity
      t.boolean :img, default: false, null: false

      t.timestamps
    end
  end
end

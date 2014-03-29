class CreateDrawings < ActiveRecord::Migration
  def change
    create_table :drawings do |t|
      t.integer :user_id
      t.text :sprites_json, :limit => 4294967295
      t.string :name
      t.integer :salt

      t.timestamps
    end
  end
end

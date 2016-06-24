class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.integer :like_count
      t.integer :hate_count

      t.timestamps null: false
    end
  end
end

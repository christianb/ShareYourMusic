class CreateCompactDisks < ActiveRecord::Migration
  def change
    create_table :compact_disks do |t|
      t.integer :user_id
      t.string :title
      t.string :artist
      t.string :genre
      t.date :date
      t.string :image_uri
      t.text :description
      t.boolean :visible

      t.timestamps
    end
  end
end

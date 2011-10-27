class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.integer :disk_id
      t.string :title

      t.timestamps
    end
  end
end

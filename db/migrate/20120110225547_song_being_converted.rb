class SongBeingConverted < ActiveRecord::Migration
  def up
    add_column :compact_disks, :song_being_converted, :boolean, :default => false
  end

  def down
    remove_column :compact_disks, :song_being_converted
  end
end

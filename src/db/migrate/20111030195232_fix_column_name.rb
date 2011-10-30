class FixColumnName < ActiveRecord::Migration
  def up
    rename_column :songs, :disk_id, :compact_disk_id
  end

  def down
     # rename back
    rename_column :songs, :compact_disk_id, :disk_id
  end
end

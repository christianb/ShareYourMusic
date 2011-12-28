class RenameLike < ActiveRecord::Migration
  def up
    rename_column :compact_disks, :like, :rank
  end

  def down
    rename_column :songs, :rank, :like
  end
end

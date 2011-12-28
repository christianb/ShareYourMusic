class CdBewertung < ActiveRecord::Migration
  def up
    add_column :compact_disks, :rank, :integer, :default => 0
  end

  def down
    remove_column :compact_disks, :rank
  end
end

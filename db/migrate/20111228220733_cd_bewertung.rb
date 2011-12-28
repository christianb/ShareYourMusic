class CdBewertung < ActiveRecord::Migration
  def up
    add_column :compact_disks, :like, :integer, :default => 0
  end

  def down
    remove_column :compact_disks, :like
  end
end

class ChangeDateToYear < ActiveRecord::Migration
  def self.up
    add_column :compact_disks, :year, :integer
    remove_column :compact_disks, :date
  end

  def self.down
    add_column :compact_disks, :date, :date
    remove_column :compact_disks, :year
  end
end

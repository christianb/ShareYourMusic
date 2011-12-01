class AddCoverToCd < ActiveRecord::Migration
  def self.up
    add_column :compact_disks, :photo_file_name, :string # Original filename
    add_column :compact_disks, :photo_content_type, :string # Mime type
    add_column :compact_disks, :photo_file_size, :integer # File size in bytes
    remove_column :compact_disks, :image_uri
  end

  def self.down
    remove_column :compact_disks, :photo_file_name
    remove_column :compact_disks, :photo_content_type
    remove_column :compact_disks, :photo_file_size
    add_column :compact_disks, :image_uri, :string
  end
end

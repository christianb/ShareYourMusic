class AddSongToCd < ActiveRecord::Migration
  def self.up
    add_column :compact_disks, :audio_file_name, :string # Original filename
    add_column :compact_disks, :audio_content_type, :string # Mime type
    add_column :compact_disks, :audio_file_size, :integer # File size in bytes
  end

  def self.down
    remove_column :compact_disks, :audio_file_name
    remove_column :compact_disks, :audio_content_type
    remove_column :compact_disks, :audio_file_size
  end
end
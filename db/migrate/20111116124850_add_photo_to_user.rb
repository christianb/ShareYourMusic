class AddPhotoToUser < ActiveRecord::Migration
  def self.up
      add_column :users, :photo_file_name, :string # Original filename
      add_column :users, :photo_content_type, :string # Mime type
      add_column :users, :photo_file_size, :integer # File size in bytes
      remove_column :users, :image_uri
    end

    def self.down
      remove_column :users, :photo_file_name
      remove_column :users, :photo_content_type
      remove_column :users, :photo_file_size
      add_column :users, :image_uri, :string, :null => false, :default => 'user_default.png'
    end
end

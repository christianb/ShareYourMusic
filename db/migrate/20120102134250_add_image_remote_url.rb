class AddImageRemoteUrl < ActiveRecord::Migration
  def up
    add_column  :users, :photo_remote_url, :string
    add_column  :compact_disks, :photo_remote_url, :string
  end

  def down
    remove_column :users, :photo_remote_url
    remove_column  :compact_disks, :photo_remote_url
  end
end

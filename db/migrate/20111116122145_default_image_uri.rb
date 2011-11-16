class DefaultImageUri < ActiveRecord::Migration
  def up
    change_column :users, :image_uri, :string, :null => false, :default => 'user_default.png'
  end
  
  def down
    change_column :users, :image_uri, :string, :null => true, :default => nil
  end
end

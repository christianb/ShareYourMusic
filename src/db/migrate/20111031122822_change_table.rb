class ChangeTable < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :role_id, :integer, :null => false
      t.change :firstname, :string, :null => false
      t.change :lastname, :string, :null => false
      t.change :email, :string, :null => false
      t.change :password, :string, :null => false
    end
    
    change_table :compact_disks do |t|
      t.change :user_id, :integer, :null => false
      t.change :title, :string, :null => false
      t.change :artist, :string, :null => false
      t.change :genre, :string, :null => false
    end
    
    change_table :roles do |t|
      t.change :role, :string, :null => false
    end
    
    change_table :songs do |t|
      t.change :compact_disk_id, :integer, :null => false
      t.change :title, :string, :null => false
    end
    
    change_table :transactions do |t|
      t.change :provider_id, :integer, :null => false
      t.change :receiver_id, :integer, :null => false
      t.change :provider_disk_id, :integer, :null => false
      t.change :receiver_disk_id, :integer, :null => false
    end
  end

  def down
    change_table :users do |t|
      t.change :role_id, :integer, :null => true
      t.change :firstname, :string, :null => true
      t.change :lastname, :string, :null => true
      t.change :email, :string, :null => true
      t.change :password, :string, :null => true
    end
    
    change_table :compact_disks do |t|
      t.change :user_id, :integer, :null => true
      t.change :title, :string, :null => true
      t.change :artist, :string, :null => true
      t.change :genre, :string, :null => true
    end
    
    change_table :roles do |t|
      t.change :role, :string, :null => true
    end
    
    change_table :songs do |t|
      t.change :compact_disk_id, :integer, :null => true
      t.change :title, :string, :null => true
    end
    
    change_table :transactions do |t|
      t.change :provider_id, :integer, :null => true
      t.change :receiver_id, :integer, :null => true
      t.change :provider_disk_id, :integer, :null => true
      t.change :receiver_disk_id, :integer, :null => true
    end
  end
end

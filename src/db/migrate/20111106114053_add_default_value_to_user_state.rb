class AddDefaultValueToUserState < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :state, :string, :null => false, :default => "active"
    end
  end
  
  def down
    change_table :users do |t|
      t.change :state, :string, :null => false
    end
  end
end

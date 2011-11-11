class ChangeRoleIdInUser < ActiveRecord::Migration
  def change
    change_column :users, :role_id, :integer, :default => 1
  end
end

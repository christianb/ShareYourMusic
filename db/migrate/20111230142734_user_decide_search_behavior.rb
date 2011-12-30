class UserDecideSearchBehavior < ActiveRecord::Migration
  def up
    add_column :users, :search_own_cds, :boolean, :default => true
  end

  def down
    remove_column :users, :search_own_cds
  end
end

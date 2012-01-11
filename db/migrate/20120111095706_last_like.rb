class LastLike < ActiveRecord::Migration
  def up
    add_column :users, :last_like, :datetime, :default => nil
  end

  def down
    remove_column :users, :last_like
  end
end

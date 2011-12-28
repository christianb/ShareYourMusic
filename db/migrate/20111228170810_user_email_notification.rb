class UserEmailNotification < ActiveRecord::Migration
  def up
    add_column :users, :email_notification, :boolean, :default => true
  end

  def down
    remove_column :users, :email_notification
  end
end

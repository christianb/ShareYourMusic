class AddDeviseColumnsToUser < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string :encrypted_password, :null => false, :default => '', :limit => 128
      t.recoverable
      t.rememberable
      t.trackable
    end
  end
  
  def down
    change_table :users do |t|
       t.remove :encrypted_password
       t.remove :password_salt
       t.remove :authentication_token
       t.remove :reset_password_token
       t.remove :reset_password_sent_at
       t.remove :remember_token
       t.remove :remember_created_at
       t.remove :sign_in_count
       t.remove :current_sign_in_at
       t.remove :last_sign_in_at
       t.remove :current_sign_in_ip
       t.remove :last_sign_in_ip
       t.remove :failed_attempts
       t.remove :unlock_token
       t.remove :locked_at
    end
  end
end

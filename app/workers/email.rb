class Email
  @queue = :email_queue
  
  def self.perform(map)
    if map['method'] == 'deletion_confirmation_compact_disk'
      Notifier.deletion_confirmation_compact_disk(map["email"], map['title'], map['artist']).deliver
    end
    
    if map['method'] == 'new_offer'
      Notifier.new_offer(map['email'], map['alias']).deliver
    end
    
    if map['method'] == 'registration_confirmation'
      Notifier.registration_confirmation(map['email'], map['password']).deliver
    end
    
    if map['method'] == 'deletion_confirmation'
      Notifier.deletion_confirmation(map['email']).deliver
    end
    
    if map['method'] == 'account_upgrade_to_admin'
      Notifier.account_upgrade_to_admin(map['email']).deliver
    end
    
    if map['method'] == 'account_downgrade_to_user'
      Notifier.account_downgrade_to_user(map['email']).deliver
    end
    
    if map['method'] == 'delete_transaction'
      user_name = map['user_name']
      email = map['email']
      Notifier.delete_transaction(email, user_name).deliver
    end
    
  end
end
class EMailDeleteDisk
  @queue = :email_queue
  
  def self.perform(email, title, artist)
    Notifier.deletion_confirmation_compact_disk(email, title, artist).deliver
  end
end
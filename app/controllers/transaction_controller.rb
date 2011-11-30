class TransactionController < ApplicationController

# neue Anfrage erstellen
def new
 # user = params[:user_id]
 # dest = params[:dest_user_id]
 # cd = params[:cd_id]
  
  cd = 3
  user = User.find(2)
  dest = User.find(3)
  message = Message.new
  message.subject = cd
  message.body = "Anfrage"
  message.sender = user
  message.recipient = dest
  message.save
end

# Anfrage löschen/ablehnen
def destroy  
  #user = params[:user_id]
  msg_id = params[:id]
  
  msg = Message.find(msg_id)
  user = msg.recipient_id
  dest = msg.sender_id 

  # subject von zuerst empfangender mail
  rsv_message = Message.read(msg_id, user)
  
  user = rsv_message.recipient
  dest = rsv_message.sender
  message = Message.new
  message.subject = rsv_message.subject
  message.body = "Abgelehnt"
  message.sender = user
  message.recipient = dest
  message.save
  
  msg.mark_deleted(user)
  message.mark_deleted(user)
  
  redirect_to :action => "index"
end

# Nachricht anzeigen
def index
  @user_id = current_user.id
   @user = User.find(@user_id)

   # Alle Anfrage
   @messages_accepted = @user.received_messages.find(:all, :conditions => ["read_at is ? and body = 'Angenommen'", nil])
   @messages_rejected = @user.received_messages.find(:all, :conditions => ["read_at is ? and body = 'Abgelehnt'", nil])
  @messages_requests = @user.received_messages.find(:all, :conditions => ["read_at is ? and body = 'Anfrage'", nil])
end

# Bestätigung der Absage
def rejected
  msg_id = params[:id]
  
  msg = Message.find(msg_id)
  msg_user = User.find(msg.recipient_id)
#  dest = msg.sender_id 
  subject = msg.subject
  
  # subject von zuerst empfangender mail
  rsv_message = Message.read(msg_id, msg_user.id)
  sent_message = msg_user.sent_messages.find(:all, :conditions => ["sender_id = ? and subject = ? and body = 'Anfrage'", msg_user.id, subject])
  
  user = rsv_message.recipient
  #dest = rsv_message.sender
  
  msg.mark_deleted(user)
  sent_message[0].mark_deleted(user)
  
  redirect_to :action => "index"
end

# nicht vergessen !!! Transaction in DB eintragen
=begin
def accept  
  user = params[:locale]
  
  # subject von zuerst empfangender mail
  rsv_message = Message.read(1, user)
  
  user = rsv_message.recipient
  dest = rsv_message.sender
  message = Message.new
  message.subject = rsv_message.subject
  message.body = "Angenommen"
  message.sender = user
  message.recipient = dest
  message.save
  
  rsv_message.mark_deleted(user)
  message.mark_deleted(user)
end
=end

def accept  
  #user = params[:user_id]
  msg_id = params[:id]
  
  msg = Message.find(msg_id)
  user = msg.recipient_id
  dest = msg.sender_id 

  # subject von zuerst empfangender mail
  rsv_message = Message.read(msg_id, user)
  
  user = rsv_message.recipient
  dest = rsv_message.sender
  message = Message.new
  message.subject = rsv_message.subject
  message.body = "Angenommen"
  message.sender = user
  message.recipient = dest
  message.save
  
  
  # CD tauschen
  cd_provider = CompactDisk.where(:id => rsv_message.subject)
  cd_receiver = CompactDisk.where(:id => 2)
  
  user = User.find(user)
  dest = User.find(dest)
  
  # Transaktion erstellen
  t = Transaction.new(:provider_id => dest.id, :receiver_id => user.id, :provider_disk_id => "3", :receiver_disk_id => "2")
  t.save
  
  cd_provider[0].user_id = dest.id
  cd_receiver[0].user_id = user.id
    
  cd_provider[0].save
  cd_receiver[0].save
  # Nachrichen löschen
  msg.mark_deleted(user)
  message.mark_deleted(user)
    
  redirect_to :action => "index"
end

# Bestätigung der Annahme
def accepted
  msg_id = params[:id]
  
  msg = Message.find(msg_id)
  #user = msg.recipient_id
  msg_user = User.find(msg.recipient_id)
  dest = msg.sender_id 
  subject = msg.subject
  
  # subject von zuerst empfangender mail
  rsv_message = Message.read(msg_id, msg_user.id)
  sent_message = msg_user.sent_messages.find(:all, :conditions => ["sender_id = ? and subject = ? and body = 'Anfrage'", msg_user.id, subject])
  
  user = rsv_message.recipient
  #dest = rsv_message.sender
  
  msg.mark_deleted(user)
  sent_message[0].mark_deleted(user)
  
  redirect_to :action => "index"
end
end

class TransactionController < ApplicationController

# neue Anfrage erstellen
def new
 # user = params[:user_id]
 # dest = params[:dest_user_id]
 # cd = params[:cd_id]
  
  cd = 1
  user = User.find(2)
  dest = User.find(4)
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
  @user_id = params[:locale]
   @user = User.find(@user_id)

   # Alle Anfrage
   @messages_accepted = @user.received_messages.find(:all, :conditions => ["read_at is ? and body = 'Anfrage'", nil])
   @messages_rejected = @user.received_messages.find(:all, :conditions => ["read_at is ? and body = 'Abgelehnt'", nil])
end

# nicht vergessen !!! Transaction in DB eintragen
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

def rejected
  msg_id = params[:id]
  
  msg = Message.find(msg_id)
  user = msg.recipient_id
  dest = msg.sender_id 
  subject = msg.subject
  
  # subject von zuerst empfangender mail
  rsv_message = Message.read(msg_id, user)
  sent_message = user.sent_messages.find(:all, :conditions => ["sender_id = ? and subject = ? and body = 'Anfrage'", user, subject])
  
  #user = rsv_message.recipient
  #dest = rsv_message.sender
  
  msg.mark_deleted(user)
  sent_message.mark_deleted(user)
  
  redirect_to :action => "index"
end

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
  
  msg.mark_deleted(user)
  message.mark_deleted(user)
  
  # Cd austauschen, Transaktion in DB eintragen
  
  redirect_to :action => "index"
end

def accepted
  msg_id = params[:id]
  
  msg = Message.find(msg_id)
  user = msg.recipient_id
  dest = msg.sender_id 
  subject = msg.subject
  
  # subject von zuerst empfangender mail
  rsv_message = Message.read(msg_id, user)
  sent_message = user.sent_messages.find(:all, :conditions => ["sender_id = ? and subject = ? and body = 'Anfrage'", user, subject])
  
  #user = rsv_message.recipient
  #dest = rsv_message.sender
  
  msg.mark_deleted(user)
  sent_message.mark_deleted(user)
  
  redirect_to :action => "index"
end
end

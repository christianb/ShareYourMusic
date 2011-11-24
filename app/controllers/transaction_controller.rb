class TransactionController < ApplicationController

# neue Anfrage erstellen
def new
 # user = params[:user_id]
 #  dest = params[:dest_user_id]
 # cd = params[:cd_id]
  
  cd = 1
  user = User.find(2)
  dest = User.find(4)
  message = Message.new
  message.subject = cd
  message.body = "0"
  message.sender = user
  message.recipient = dest
  message.save
end

# Anfrage löschen/ablehnen
def delete  
  user = params[:user_id]

  # subject von zuerst empfangender mail
  message = Message.read(1, user)
  
end
end

class TransactionController < ApplicationController

# neue Anfrage erstellen
def create
  cd_visible = true
 
  # User_ID des Tauschpartners
  user_id = params[:user_id]
  
  # Nachrichtentext
  body = params[:body]
 
  # CDs die getauscht werden sollen
  cd_mine = params[:cds_mine]
  cd_wanted = params[:cds_wanted]
 
  # einzelne CD IDs 
  seperated_mine_cds = cd_mine.split(',')
  seperated_wanted_cds = cd_wanted.split(',')
 
  # Nutzerdaten ermitteln
  user = User.find(current_user.id)
  dest = User.find(user_id)
  
  # CDs suchen die nicht Sichtbar sind
  @disks_mine = CompactDisk.where(:id => seperated_mine_cds, :visible => false)
  @disks_wanted = CompactDisk.where(:id => seperated_wanted_cds, :visible => false)

  # Anfrage nur erstellen wenn CD noch visible ist, d.h Arrays der vorherigen Abfrage sind leer
  if (@disks_mine.empty? || @disks_wanted.empty?)
    params = {
      'method' => 'new_offer',
      'email' => dest.email,
      'alias' => user.alias
    }
    
    Resque.enqueue(Email, params)
    #Notifier.new_offer(dest.email, user.alias).deliver
  
    message = Message.new
    message.subject = "#{cd_mine};#{cd_wanted}"
    message.body = "Anfrage"
    message.sender = user
    message.recipient = dest
    if message.save
      CompactDisk.update_all({:visible => false, :in_transaction => true}, {:id => seperated_mine_cds}) 
      CompactDisk.update_all({:visible => false, :in_transaction => true}, {:id => seperated_wanted_cds})        
      redirect_to transaction_index_path
    end
    else
      redirect_to :controller => "compact_disk", :action => "index"
      flash[:notice] = "Mindestens eine CD ist nicht mehr fuer einen Tausch verfuegbar"
    end
end

# Anfrage löschen/ablehnen
def destroy  
  msg_id = params[:id]

  msg = Message.find(msg_id)
  
  subj_splitted = msg.subject.split(';')
  cds_splitted = subj_splitted[0].split(',') + subj_splitted[1].split(',')   
  
  # user -> Nutzer der Nachricht (Anfrage) empfangen hat
  # dest -> Nutzer der benachrichtigt werden soll, dass Anfrage abgelehnt wurde
  user = msg.recipient_id
  dest = msg.sender_id 

  rsv_message = Message.read(msg_id, user)

  user = rsv_message.recipient
  dest = rsv_message.sender
  
  # Antwort an Sender das Anfrage abgelehnt wurde
  message = Message.new
  message.subject = rsv_message.subject
  message.body = "Abgelehnt; #{msg_id}"
  message.sender = user
  message.recipient = dest
  message.save
  
  # Nachrichten als gelöscht markieren; Sobald Empfänger dies auch macht, wird Nachricht gelöscht
  msg.mark_deleted(user)
  message.mark_deleted(user)
  
  CompactDisk.update_all({:visible => true, :in_transaction => false}, {:id => cds_splitted}) 

  redirect_to :action => "index"
end

def destroy_sent_msg
  msg_id = params[:id]

  msg = Message.find(msg_id)
  
  # user -> Nutzer der Nachricht (Anfrage) empfangen hat
  # dest -> Nutzer der benachrichtigt werden soll, dass Anfrage abgelehnt wurde
  user = msg.recipient_id
  dest = msg.sender_id 

  rsv_message = Message.read(msg_id, user)

  user = rsv_message.recipient
  dest = rsv_message.sender
  if !msg.body.include?('Modifikation')
    subj_splitted = msg.subject.split(';')
    cds_splitted = subj_splitted[0].split(',') + subj_splitted[1].split(',')   
    # Nachrichten als gelöscht markieren; Sobald Empfänger dies auch macht, wird Nachricht gelöscht
    msg.destroy
  
    CompactDisk.update_all({:visible => true, :in_transaction => false}, {:id => cds_splitted}) 
   
    redirect_to :action => "index"
  else
    splitted_body = msg.body.split(';')
    prev_msg_id = splitted_body[1]
    prev_msg = Message.find(prev_msg_id)
    
    subj_splitted = msg.subject.split(';')
    cds_splitted = subj_splitted[2].split(',') + subj_splitted[3].split(',')   
    # Nachrichten als gelöscht markieren; Sobald Empfänger dies auch macht, wird Nachricht gelöscht
    msg.destroy
    prev_msg.destroy
    CompactDisk.update_all({:visible => true, :in_transaction => false}, {:id => cds_splitted}) 
   
    redirect_to :action => "index"
  end
end

# Nachricht anzeigen
def index
  @user_id = current_user.id
  @user = User.find(@user_id)
  
  # Alle Anfrage
  @messages_accepted = @user.received_messages.find(:all, :conditions => ["read_at is ? and body LIKE '%Angenommen%'", nil])
  @messages_rejected = @user.received_messages.find(:all, :conditions => ["read_at is ? and body LIKE '%Abgelehnt%'", nil])
  @messages_requests = @user.received_messages.find(:all, :conditions => ["read_at is ? and body LIKE '%Anfrage%'", nil])
  @messages_modified = @user.received_messages.find(:all, :conditions => ["read_at is ? and body LIKE '%Modifikation%'", nil])
  @sent_messages = @user.sent_messages(:all);  

end

# Bestätigung der Absage
def rejected
  msg_id = params[:id]

  msg = Message.find(msg_id)
  
  splitted_body = msg.body.split(';')
  prev_msg_id = splitted_body[1]
  
  # current_user?
  msg_user = User.find(msg.recipient_id)
  
  subject = msg.subject

  # Aktuelle Nachricht als gelesen markieren
  rsv_message = Message.read(msg_id, msg_user)
  
  # Vorgänger Nachricht
  #sent_message = msg_user.sent_messages.find(:all, :conditions => ["sender_id = ? and subject = ? and body LIKE '%Anfrage%'", msg_user.id, subject])
  
  sent_message = msg_user.sent_messages.find(prev_msg_id)
  
  user = rsv_message.recipient
  #dest = rsv_message.sender
  
#  msg.mark_deleted(user)
#  sent_message.mark_deleted(user)
  msg.destroy
  sent_message.destroy

  redirect_to :action => "index"
end

# Anfrage annehmen
def accept  
  #user = params[:user_id]
  msg_id = params[:id]

  msg = Message.find(msg_id)
  user = msg.recipient_id
  #dest = msg.recipient_id
  dest = msg.sender_id 
  #user = msg.sender_id 

  rsv_message = Message.read(msg_id, user)

  cds = rsv_message.subject

  cd_array = cds.split(';')

  tauschCDs = cd_array[0].split(',')
  wunschCDs = cd_array[1].split(',')

  user = rsv_message.recipient
  dest = rsv_message.sender
  message = Message.new
  message.subject = rsv_message.subject
  message.body = "Angenommen; #{msg_id}"
  message.sender = user
  message.recipient = dest
  message.save

#    CompactDisk.update_all({:visible => false}, {:id => seperated_mine_cds})
#    CompactDisk.update_all({:visible => false}, {:id => seperated_wanted_cds})

  # CD tauschen
  #cd_provider = CompactDisk.where(:id => rsv_message.subject)
  #cd_receiver = CompactDisk.where(:id => 2)

#  user = User.find(user)
#  dest = User.find(dest)
  
  # CDs suchen die nicht mehr sichtbar (verfügbar) sind
  @tausch_visible = CompactDisk.where(:id => tauschCDs, :visible => false)
  @wunsch_visible = CompactDisk.where(:id => wunschCDs, :visible => false)
  
  still_myCDs = CompactDisk.where(:id => tauschCDs, :user_id => current_user.id)

  #if @tausch_visible.empty? && @wunsch_visible.empty? && (still_myCDs.size == tauschCDs.size)
    # Transaktion erstellen
    t = Transaction.new(:provider_id => dest.id, :receiver_id => user.id, :provider_disk_id => "2".to_i, :receiver_disk_id => "3".to_i)
    t.save
  
    CompactDisk.update_all({:user_id => user.id, :visible => false, :in_transaction => false}, {:id => tauschCDs})
    CompactDisk.update_all({:user_id => dest.id, :visible => false, :in_transaction => false}, {:id => wunschCDs})
    
    tauschCDs.each do |tcd|
      sp = SwapProvider.new(:transaction_id => t.id, :compact_disk_id => tcd.to_i)
      sp.save
    end
    
    wunschCDs.each do |wcd|
      sr = SwapReceiver.new(:transaction_id => t.id, :compact_disk_id => wcd.to_i)
      sr.save
    end
    

    # Nachrichen löschen
    msg.mark_deleted(user)
    message.mark_deleted(user)

    redirect_to :action => "index"
  #else
   # redirect_to :action => "index"
    #flash[:notice] = "Mindestens eine der CDs ist nicht mehr verfuegbar"
    #msg.mark_deleted(user)
    #message.mark_deleted(user)
  #end
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
  sent_message = msg_user.sent_messages.find(:all, :conditions => ["sender_id = ? and subject = ? and body LIKE '%Anfrage%'", msg_user.id, subject])

  user = rsv_message.recipient
  #dest = rsv_message.sender

  msg.mark_deleted(user)
  sent_message[0].mark_deleted(user)
  
  redirect_to :action => "index"
end

# Daten aktueller Anfrage abrufen, um diese zu modifizieren
def modifyRequest
  @msg_id = params[:id]
  msg = Message.find(@msg_id)
  @msg_subject = msg.subject
  
  @user = User.find(msg.sender_id)
  @userCDs = CompactDisk.where(:user_id => @user.id, :visible => true, :in_Transaction => false)
  
  @myCDs = CompactDisk.where(:user_id => current_user.id, :visible => true, :in_Transaction => false)
end

def modify
  #user = params[:user_id]
  #msg_id = params[:id]
  msg_id = params[:msg_id]
  #prev_msg_id = params[:prev_msg_id]
  
  # Modifiezierte Anfrage
  modified_mine = params[:cds_wanted]
  modified_wanted = params[:cds_mine]
  
  splitted_mine = modified_mine.split(',')
  splitted_wanted = modified_wanted.split(',')
    
  msg = Message.find(msg_id)
  
  # Empfänger Org. Message ist jest der Sender
  user = msg.recipient_id
  # Sender der Org. Message ist jetzt Empfänger der neuen Nachricht
  dest = msg.sender_id 

  # subject von zuerst empfangender mail
  rsv_message = Message.read(msg_id, user)

  user = rsv_message.recipient
  dest = rsv_message.sender
  message = Message.new
  message.subject = rsv_message.subject + ";#{modified_mine};#{modified_wanted}"
  message.body = "Modifikation; #{msg_id}"
  message.sender = user
  message.recipient = dest
  message.save
  
  CompactDisk.update_all({:visible => false, :in_transaction => true}, {:id => splitted_mine})
  CompactDisk.update_all({:visible => false, :in_transaction => true}, {:id => splitted_wanted})
  

  msg.mark_deleted(user)
  #message.mark_deleted(user)
  #msg.destroy

  redirect_to :action => "index"
end

def modifyAccept
  msg_id = params[:id]

  msg = Message.find(msg_id)

  msg_user = User.find(msg.recipient_id)

  # Quelle der Msg ist neuer Besitzer der CD
  dest = msg.sender_id 

  subject = msg.subject

  # Nachricht lesen
  rsv_message = Message.read(msg_id, msg_user.id)

  # CD IDs aus Subject
  cds = rsv_message.subject

  # Splitten
  cd_array = cds.split(';')

  tauschCDs = cd_array[0]
  wunschCDs = cd_array[1]

  # neuen Subject erstellen
  subject = cd_array[0] + ';' + cd_array[1]

  #subject = subject.to_s
  #subject = subject.join ';'
  
  # CDs suchen die nicht mehr sichtbar (verfügbar) sind
  #@tausch_visible = CompactDisk.where(:id => tauschCDs, :visible => false)
  #@wunsch_visible = CompactDisk.where(:id => wunschCDs, :visible => false)

  
  sent_message = msg_user.sent_messages.find(:all, :conditions => ["sender_id = ? and subject = ? and body LIKE '%Anfrage%'", msg_user.id, subject])

  user = rsv_message.recipient
  dest = rsv_message.sender
  msg.mark_deleted(user)
  sent_message[0].mark_deleted(user)
  
  # prüfen ob alle CDs verfügbar sind
 # if @tausch_visible.empty? && @wunsch_visible.empty?
    message = Message.new
    message.subject = rsv_message.subject
    message.body = "MAngenommen; #{msg_id}"
    message.sender = user
    message.recipient = dest
    message.save

    message.mark_deleted(user)

    tauschCDs_neu = cd_array[2].split(',')
    wunschCDs_neu = cd_array[3].split(',')


    # Transaktion erstellen
    t = Transaction.new(:provider_id => dest.id, :receiver_id => user.id, :provider_disk_id => "2".to_i, :receiver_disk_id => "3".to_i)
    t.save
    
    CompactDisk.update_all({:user_id => dest.id, :visible => false, :in_transaction => false}, {:id => tauschCDs_neu})
    CompactDisk.update_all({:user_id => user.id, :visible => false, :in_transaction => false}, {:id => wunschCDs_neu})
    
    tauschCDs_neu.each do |tcd|
      sp = SwapProvider.new(:transaction_id => t.id, :compact_disk_id => tcd.to_i)
      sp.save
    end
 
    wunschCDs_neu.each do |wcd|
      sr = SwapReceiver.create(:transaction_id => t.id, :compact_disk_id => wcd.to_i)
      sr.save
    end
    
    #CompactDisk.update_all({:visible => false, :in_transaction => false}, {:id => tauschCDs_neu})
    #CompactDisk.update_all({:visible => false, :in_transaction => false}, {:id => wunschCDs_neu})
    
    
=begin    
    tauschCDs_neu.each do |e|
      sp = SwapProvider.new(:transaction_id => t.id, :compact_disk_id => e.to_i)
      sp.save

      disk = CompactDisk.where(:id => e.to_i)
      disk[0].user_id = dest.id
      disk[0].visible = false
      disk[0].save
    end

    wunschCDs_neu.each do |e|
      sr = SwapReceiver.new(:transaction_id => t.id, :compact_disk_id => e.to_i)
      sr.save

      disk = CompactDisk.where(:id => e.to_i)
      disk[0].user_id = user.id
      disk[0].visible = false
      disk[0].save
    end
=end
    redirect_to :action => "index"
 # else
#    redirect_to :action => "index"
 #   flash[:notice] = "Mindestens eine der CDs ist nicht mehr verfuegbar"
#    message.mark_deleted(user)
 # end
end

def modifyAccepted
   msg_id = params[:id]

    msg = Message.find(msg_id)
    msg_user = User.find(msg.recipient_id)
  #  dest = msg.sender_id 
    subject = msg.subject

    # subject von zuerst empfangender mail
    rsv_message = Message.read(msg_id, msg_user.id)
    sent_message = current_user.sent_messages.find(:all, :conditions => ["body LIKE ? AND subject LIKE ?", "%Modifikation%", subject])

    user = rsv_message.recipient
    #dest = rsv_message.sender

    msg.destroy
    sent_message[0].destroy
    #sent_message[0].mark_deleted(user)

    redirect_to :action => "index"
end

def modifyReject
    msg_id = params[:id]

    msg = Message.find(msg_id)
    msg_user = User.find(msg.recipient_id)
    dest = msg.sender_id 
    subject = msg.subject


    # subject von zuerst empfangender mail
    rsv_message = Message.read(msg_id, msg_user.id)

    cds = rsv_message.subject
    cd_array = cds.split(';')

    tauschCDs = cd_array[0]
    wunschCDs = cd_array[1]
    tauschCDs_neu = cd_array[2].split(',')
    wunschCDs_neu = cd_array[3].split(',')
    
  #  subject = tauschCDs + wunschCDs
    subject = cd_array[0] + ';' + cd_array[1]
    #subject = subject.to_s
    #subject = subject.join ';'

    sent_message = msg_user.sent_messages.find(:all, :conditions => ["sender_id = ? and subject = ? and body LIKE '%Anfrage%'", msg_user.id, subject])

    user = rsv_message.recipient
    dest = rsv_message.sender
    msg.mark_deleted(user)
    sent_message[0].mark_deleted(user)


    message = Message.new
    message.subject = rsv_message.subject
    message.body = "MAbgelehnt; #{msg_id}"
    message.sender = user
    message.recipient = dest
    message.save

    CompactDisk.update_all({:visible => true, :in_transaction => false}, {:id => tauschCDs_neu})
    CompactDisk.update_all({:visible => true, :in_transaction => false}, {:id => wunschCDs_neu})

    message.mark_deleted(user)

    redirect_to :action => "index"
end

def modifyRejected
    msg_id = params[:id]
    msg = Message.find(msg_id)
    msg_user = User.find(msg.recipient_id)
  #  dest = msg.sender_id 
    subject = msg.subject

    splitted_body = msg.body.split(';')
    prev_msg_id = splitted_body[1]
    prev_msg = Message.find(prev_msg_id)
    
    # subject von zuerst empfangender mail
    rsv_message = Message.read(msg_id, msg_user.id)
    #sent_message = msg_user.sent_messages.find(:all, :conditions => ["sender_id = ? and subject = ? and body LIKE '%Anfrage%'", msg_user.id, subject])

    user = rsv_message.recipient
    #dest = rsv_message.sender

    msg.mark_deleted(user)
    #sent_message[0].mark_deleted(user)
    prev_msg.destroy
    
    redirect_to :action => "index"
end

def history
  @transactions = Transaction.where("provider_id = ? OR receiver_id = ?", current_user.id, current_user.id).paginate(:page => params[:page], :per_page => 10)
end
end

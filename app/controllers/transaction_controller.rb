class TransactionController < ApplicationController
  
  # neue Anfrage erstellen
  def new
  
  cd_visible = true
   # User_ID des Tauschpartners
   user_id = params[:user_id]
   
   # dest = params[:dest_user_id]
   
   # CDs die getauscht werden sollen
   cd_mine = params[:cds_mine]
   cd_wanted = params[:cds_wanted]
   
   # einzelne CD IDs 
   seperated_wanted_cds = cd_wanted.split(',')
   seperated_wanted_cds.each do |swcd|
     
     # prüfen ob eine der CD nicht visible ist 
     if (!CompactDisk.find(swcd).visible)
       cd_visible = false
       break;
     end
     
   end
   
    # Nutzerdaten ermitteln
    user = User.find(current_user.id)
    dest = User.find(user_id)
    
    # Anfrage nur erstellen wenn CD noch visible ist
    if (cd_visible)
      Notifier.new_offer(dest.email, user.alias).deliver
    
      message = Message.new
      #message.subject = "#{cd_wanted};#{cd_mine}"
      message.subject = "#{cd_mine};#{cd_wanted}"
      message.body = "Anfrage; Hallo, ich tausche 2 CDs gegen Chuck Norris"
      message.sender = user
      message.recipient = dest
      if message.save
        redirect_to :controller => "compact_disk", :action => "index"
      end
    else
      redirect_to :controller => "compact_disk", :action => "index"
      flash[:notice] = "Mindestens eine CD ist nicht mehr fuer einen Tausch verfuegbar"
    end
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
    message.body = "Abgelehnt; Will nicht"
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
    @messages_accepted = @user.received_messages.find(:all, :conditions => ["read_at is ? and body LIKE '%Angenommen%'", nil])
    @messages_rejected = @user.received_messages.find(:all, :conditions => ["read_at is ? and body LIKE '%Abgelehnt%'", nil])
    @messages_requests = @user.received_messages.find(:all, :conditions => ["read_at is ? and body LIKE '%Anfrage%'", nil])
    @messages_modified = @user.received_messages.find(:all, :conditions => ["read_at is ? and body LIKE '%Modifikation%'", nil])
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
    sent_message = msg_user.sent_messages.find(:all, :conditions => ["sender_id = ? and subject = ? and body LIKE '%Anfrage%'", msg_user.id, subject])

    user = rsv_message.recipient
    #dest = rsv_message.sender

    msg.mark_deleted(user)
    sent_message[0].mark_deleted(user)

    redirect_to :action => "index"
  end

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
    message.body = "Angenommen; Na klar"
    message.sender = user
    message.recipient = dest
    message.save


    # CD tauschen
    #cd_provider = CompactDisk.where(:id => rsv_message.subject)
    #cd_receiver = CompactDisk.where(:id => 2)

    user = User.find(user)
    dest = User.find(dest)

    # Transaktion erstellen
    t = Transaction.new(:provider_id => dest.id, :receiver_id => user.id, :provider_disk_id => "2".to_i, :receiver_disk_id => "3".to_i)
    t.save

    tauschCDs.each do |e|
      sp = SwapProvider.new(:transaction_id => t.id, :compact_disk_id => e.to_i)
      sp.save

      disk = CompactDisk.where(:id => e.to_i)
      disk[0].user_id = user.id
      disk[0].visible = false
      disk[0].save
    end

    wunschCDs.each do |e|
      sr = SwapReceiver.new(:transaction_id => t.id, :compact_disk_id => e.to_i)
      sr.save

      disk = CompactDisk.where(:id => e.to_i)
      disk[0].user_id = dest.id
      disk[0].visible = false
      disk[0].save
    end


    #cd_provider[0].user_id = dest.id
    #cd_receiver[0].user_id = user.id

    #cd_provider[0].save
    #cd_receiver[0].save

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
    sent_message = msg_user.sent_messages.find(:all, :conditions => ["sender_id = ? and subject = ? and body LIKE '%Anfrage%'", msg_user.id, subject])

    user = rsv_message.recipient
    #dest = rsv_message.sender

    msg.mark_deleted(user)
    sent_message[0].mark_deleted(user)

    redirect_to :action => "index"
  end
  
  def modifyRequest
    @msg_id = params[:id]
    msg = Message.find(@msg_id)
    @msg_subject = msg.subject
    
    @user = User.find(msg.sender_id)
    @userCDs = CompactDisk.where(:user_id => @user.id)
    
    @myCDs = CompactDisk.where(:user_id => current_user.id)
  end
  
  def modify
    #user = params[:user_id]
    msg_id = params[:id]
    
    # Modifiezierte Anfrage
    modified_mine = params[:cds_wanted]
    modified_wanted = params[:cds_mine]

    msg = Message.find(msg_id)
    user = msg.recipient_id
    dest = msg.sender_id 

    # subject von zuerst empfangender mail
    rsv_message = Message.read(msg_id, user)

    user = rsv_message.recipient
    dest = rsv_message.sender
    message = Message.new
    message.subject = rsv_message.subject + ";#{modified_mine};#{modified_wanted}"
    message.body = "Modifikation; Will anders haben!!!"
    message.sender = user
    message.recipient = dest
    message.save

    msg.mark_deleted(user)
    message.mark_deleted(user)

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

    #subject = tauschCDs + wunschCDs

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
    message.body = "MAngenommen; Klar"
    message.sender = user
    message.recipient = dest
    message.save

    message.mark_deleted(user)

    #user = User.find(dest)
    #dest = User.find(user)

    tauschCDs_neu = cd_array[2].split(',')
    wunschCDs_neu = cd_array[3].split(',')


    # Transaktion erstellen
    t = Transaction.new(:provider_id => dest.id, :receiver_id => user.id, :provider_disk_id => "2".to_i, :receiver_disk_id => "3".to_i)
    t.save

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

    redirect_to :action => "index"
  end

  def modifyAccepted
     msg_id = params[:id]

      msg = Message.find(msg_id)
      msg_user = User.find(msg.recipient_id)
    #  dest = msg.sender_id 
      subject = msg.subject

      # subject von zuerst empfangender mail
      rsv_message = Message.read(msg_id, msg_user.id)
      #sent_message = msg_user.sent_messages.find(:all, :conditions => ["sender_id = ? and subject = ? and body LIKE '%Anfrage%'", msg_user.id, subject])

      user = rsv_message.recipient
      #dest = rsv_message.sender

      msg.mark_deleted(user)
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
      message.body = "MAbgelehnt; Will nicht"
      message.sender = user
      message.recipient = dest
      message.save

      message.mark_deleted(user)

      redirect_to :action => "index"
  end

  def modifyRejected
      msg_id = params[:id]

      msg = Message.find(msg_id)
      msg_user = User.find(msg.recipient_id)
    #  dest = msg.sender_id 
      subject = msg.subject

      # subject von zuerst empfangender mail
      rsv_message = Message.read(msg_id, msg_user.id)
      #sent_message = msg_user.sent_messages.find(:all, :conditions => ["sender_id = ? and subject = ? and body LIKE '%Anfrage%'", msg_user.id, subject])

      user = rsv_message.recipient
      #dest = rsv_message.sender

      msg.mark_deleted(user)
      #sent_message[0].mark_deleted(user)

      redirect_to :action => "index"
  end
end

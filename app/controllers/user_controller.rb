  class UserController < ApplicationController
  before_filter :set_locale
  before_filter :isAdmin, :only =>[:set_as_admin, :set_as_user]
  
  def isAdmin
    unless (user_signed_in? && AdminController.isAdmin(current_user))
       redirect_to :back
    end
  end
  
  # just print some attributes of a user
  # GET /user/1
  def show
      @user = User.find(params[:id]);
  end  
  
  def reset_password
    user = params[:user]
    email = user["email"]
    #logger.debug "email: "
    #logger.debug email
    array = User.where(:email => email)
    @user = array[0]
    
    if !@user.nil?
      password_length = 8
      password = Devise.friendly_token.first(password_length)
      @user.update_attribute(:password, password)
    
      #logger.debug "password: "
      #logger.debug @_new_password
      
      params = {
        'method' => 'registration_confirmation',
        'email' => email,
        'password' => password
      }
      
      Resque.enqueue(Email, params)
      
      #Notifier.registration_confirmation(email, password).deliver
      flash[:notice] = "Password versendet."
      redirect_to welcome_path
    else
      flash[:alert] = "Email Adresse nicht bekannt!"
      redirect_to :back
    end
  end
  
  def most_active
    if (user_signed_in?)
      @users = User.where(User.arel_table[:id].not_eq(current_user.id)).order("sign_in_count DESC").limit(10)
    else
      @users = User.order("sign_in_count DESC").limit(10)
    end
  end
  
  def destroy
    logger.debug "call destroy user"
    logger.debug "destroy user for id: "+:id.to_s
      @user = User.find(params[:id])
      #if (@user.email_notification)
      
      if current_user.id != @user.id
       params = {
          'method' => 'deletion_confirmation',
          'email' => @user.email
        }
        
        Resque.enqueue(Email, params)
      end
        #Notifier.deletion_confirmation(@user.email).deliver
      #end
      name = @user.firstname+" "+@user.lastname
      
      # Alle Nachristen eines Users finden
      sent = @user.sent_messages.find(:all)
      received = @user.received_messages.find(:all)
      
      # IDs der Nutzer an die Nachrichten/Anfragen verschickt wurden oder von denen welche Empfangen wurden
      user_ids = Array.new
      
      # IDs von Sender Empfänger auslesen und in Array user_ids speichern
      sent.each do |s|
        user_ids.push(s.recipient_id)
      end
      
      # IDs von Sender Empfänger auslesen und in Array user_ids speichern
      received.each do |r|
        user_ids.push(r.sender_id)
      end
      
      user_ids.each do |id|
        user = User.find(id)
        params = {
          'method' => 'delete_transaction',
          'user_name' => @user.firstname+" "+@user.lastname,
          'email' => user.email
        }
    
        Resque.enqueue(Email, params)
      end
      # Alle Nachrichten eines Users löschen
      Message.delete_all(:id => sent)
      Message.delete_all(:id => received)
      
      flash[:notice] = "Benutzer: "+name+" erfolgreich geloescht."
      
      # logout user
      #if current_user.id == @user.id
        #
        #@user.destroy  
        #redirect_to :back
      #else
        if signed_in?(@user)
          sign_out(@user)
        end
        
        # löschen aller song files
        cds = CompactDisk.where(:user_id => @user.id)
        cds.each { |cd|
          path = cd.audio.path
          if !cd.audio_file_name.nil?
            filename_with_ext = cd.audio_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')
            path = path.chomp(filename_with_ext)
            system("rm -rf #{path}")
          end
        }
        
        
        if current_user.id == @user.id
          redirect_to welcome_path
        else
          redirect_to :back
        end
        
        @user.destroy
      #end
  end
  
  def set_as_admin
    @user = User.find(params[:id])
    @user.update_attribute(:role_id, User.admin);
    if (@user.email_notification)
      params = {
        'method' => 'account_upgrade_to_admin',
        'email' => @user.email,
      }
      
      Resque.enqueue(Email, params)
      #Notifier.account_upgrade_to_admin(@user.email).deliver
    end
    redirect_to :back
  end
  
  def set_as_user
    @user = User.find(params[:id])
    @user.update_attribute(:role_id, User.user);
    if (@user.email_notification)
      params = {
        'method' => 'account_downgrade_to_user',
        'email' => @user.email,
      }
      
      Resque.enqueue(Email, params)
      #Notifier.account_downgrade_to_user(@user.email).deliver
    end
    redirect_to :back
  end
end

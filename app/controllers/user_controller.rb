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
      Notifier.registration_confirmation(email, password).deliver
      flash[:notice] = "Password versendet."
      redirect_to welcome_path
    else
      flash[:alert] = "Email Adresse nicht bekannt!"
      redirect_to :back
    end
  end
  
  def most_active
    if (user_signed_in?)
      @users = User.where(User.arel_table[:id].not_eq(current_user.id)).order("sign_in_count DESC").limit(9)
    else
      @users = User.order("sign_in_count DESC").limit(9)
    end
  end
  
  def destroy
      @user = User.find(params[:id])
      if (@user.email_notification)
        Notifier.deletion_confirmation(@user.email).deliver
      end
      name = @user.firstname+" "+@user.lastname
      @user.destroy
      flash[:notice] = "Benutzer: "+name+" erfolgreich geloescht."
      redirect_to :back
  end
  
  def set_as_admin
    @user = User.find(params[:id])
    @user.update_attribute(:role_id, User.admin);
    if (@user.email_notification)
      Notifier.account_upgrade_to_admin(@user.email).deliver
    end
    redirect_to :back
  end
  
  def set_as_user
    @user = User.find(params[:id])
    @user.update_attribute(:role_id, User.user);
    if (@user.email_notification)
      Notifier.account_downgrade_to_user(@user.email).deliver
    end
    redirect_to :back
  end
end

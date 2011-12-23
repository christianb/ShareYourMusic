  class UserController < ApplicationController
  before_filter :set_locale
  
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
    
    password_length = 8
    password = Devise.friendly_token.first(password_length)
    @user.update_attribute(:password, password)
    
    #logger.debug "password: "
    #logger.debug @_new_password
    Notifier.registration_confirmation(email, password).deliver
    redirect_to welcome_path
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
      Notifier.deletion_confirmation(@user.email).deliver
      
      @user.destroy
      redirect_to :back
  end
  
  def set_as_admin
    @user = User.find(params[:id])
    @user.update_attribute(:role_id, User.admin);
    Notifier.account_upgrade_to_admin(@user.email).deliver
    redirect_to :back
  end
  
  def set_as_user
    @user = User.find(params[:id])
    @user.update_attribute(:role_id, User.user);
    Notifier.account_downgrade_to_user(@user.email).deliver
    redirect_to :back
  end
end

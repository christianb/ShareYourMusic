  class UserController < ApplicationController
  before_filter :set_locale
  
  # just print some attributes of a user
  # GET /user/1
  def show
    if !user_signed_in?
      @user = User.find(params[:id]);
    else
      @user = current_user
    end
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
end

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
  
  # Suche nach einem Benutzer
  # Suche in Firstname, Lastname, eMail und Alias
  def self.search(name)
    User.where("firstname LIKE ? OR lastname LIKE ? OR email LIKE ? OR alias LIKE ?","%#{name}%","%#{name}%","%#{name}%","%#{name}%")
  end
end

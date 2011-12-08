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
  
  # search for a user with a given name
  def self.search(name)
    User.where("firstname LIKE ? OR lastname LIKE ?","%#{name}%","%#{name}%")
  end
end

class UserController < ApplicationController
  
  # just print some attributes of a user
  # GET /user/1
  def show
    if !user_signed_in?
      @user = User.find(params[:id]);
    else
      @user = current_user
    end
  end  
end

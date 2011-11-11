class UserController < ApplicationController
  
  # just print some attributes of a user
  # GET /user/1
  def show
    @user = User.find(params[:id]);
  end  
end

class UserController < ApplicationController
  
  # just print some attributes of a user
  # GET /user/1
  def show
    @user = User.find(params[:id]);
  end
  
  # POST /user
  # Übertragung der Daten nach der Registrierung
  def create
    # User Attribute einfügen nach Registrierung
  end
  
  # GET /user/new
  # Wird bei der registrierung eines neuen Benutzers aufgerufen
  def new
    @user = User.new
      # Aufrufen des Templates zur Registrierung
  end
  
  # GET /user/1/edit
  def edit
    @user = User.find(params[:id])
  end
  
  # PUT /user/1
  def update
    @user = User.find(params[:id])
    
    respond_to do |format|
        
        if @user.update_attributes(params[:user])
          format.html  { redirect_to(:action => "show",
                        :notice => 'User was successfully updated.') }
          #format.json  { render :json => {}, :status => :ok }
        else
          format.html  { render :action => "edit" }
          #format.json  { render :json => @post.errors,
                        #:status => :unprocessable_entity }
        end
      end
  end
  
  def destroy
    @user = User.find(params[:id]) 
    @user.destroy
    respond_to do |format| 
      format.html { redirect_to(:path => "/") } 
      format.xml { head :ok }
    end
  end
  
end

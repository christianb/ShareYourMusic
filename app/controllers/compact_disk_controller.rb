class CompactDiskController < ApplicationController
  before_filter :set_locale
  load_and_authorize_resource :only => [:show, :destroy]
  
  def index
    #@cds = CompactDisk.where(:user_id => current_user.id)
    @cds = CompactDisk.all
  end
  
  def myCDs
    #@allCDs = CompactDisk.all
    @myCDs = CompactDisk.where(:user_id => current_user.id)
  end
  
  def show
    @cd = CompactDisk.find(params[:id])
  end
  
  def destroy
    @cd = CompactDisk.find(params[:id])
    @cd.destroy
    redirect_to :action => "index"
  end
  
  def new
    @cd = CompactDisk.new
  end
  
  def create
    @cd = CompactDisk.new(params[:compact_disk])
    respond_to do |format|
        if @cd.save
          format.html  { redirect_to(compact_disk_index_path,
                        :notice => 'CD was successfully created.') }
          format.json  { render :json => @cd,
                        :status => :created, :location => @cd }
        else
          format.html  { render :action => "new" }
          format.json  { render :json => @cd.errors,
                        :status => :unprocessable_entity }
        end
      end
  end
  
  def edit
    @cd = CompactDisk.find(params[:id])
  end
  
  def update
    @cd = CompactDisk.find(params[:id])

    respond_to do |format|
      if @cd.update_attributes(params[:compact_disk])
        format.html { render action: "show" }
      else
        format.html { render action: "edit" }
      end
    end
  end
  
  def find_by_artist
    @cd = CompactDisk.where
  end
  
  def swap
    
  end
  
  # search for a user with a given name
  def self.search(name)
    CompactDisk.where("artist LIKE ? OR title LIKE ?","%#{name}%","%#{name}%")
  end
end

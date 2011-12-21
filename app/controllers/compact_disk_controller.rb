class CompactDiskController < ApplicationController
  before_filter :set_locale
  #load_and_authorize_resource :only => [:show, :destroy]
  
  def index
    #@cds = CompactDisk.where(:user_id => current_user.id)
    #@cds = CompactDisk.all
    @cds = CompactDisk.where(CompactDisk.arel_table[:user_id].not_eq(current_user.id)).paginate(:page => params[:page], :per_page => 9)
  end
  
  def myCDs
    #@allCDs = CompactDisk.all
   # @myCDs = CompactDisk.where(:user_id => current_user.id)
    @myCDs = CompactDisk.where(:user_id => current_user.id).paginate(:page => params[:page], :per_page => 9)

  end
  
  def show
    @cd = CompactDisk.find(params[:id])
    @songs = Song.where(:compact_disk_id => @cd.id)
    @user = User.find(@cd.user_id)
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
    @songs = (params[:song])  
    
    respond_to do |format|
        if @cd.save
          format.html  { redirect_to(compact_disk_index_path,
                        :notice => 'CD was successfully created.') }
          format.json  { render :json => @cd,
                        :status => :created, :location => @cd }
          
          @songs.each do |s|
              @song  = Song.new(:compact_disk_id => @cd.id, :title => s[1])
              @song.save
          end
        else
          format.html  { render :action => "new" }
          format.json  { render :json => @cd.errors,
                        :status => :unprocessable_entity }
        end
      end
  end
  
  def edit
    @cd = CompactDisk.find(params[:id])
    #@songs = Song.where(:compact_disk_id => @cd.id)
    #@cd.songs.build
    
  end
  
  def update
    @cd = CompactDisk.find(params[:id])
#    @songs = params[:song]
#    .except(:song)
    respond_to do |format|
      if @cd.update_attributes(params[:compact_disk])
        #allsongs = Song.where(:all, :compact_disk_id => @cd.id)
        #allsongs.each do |as|
        #  if as.id == params[:song][:index]
        #    as.title = params[:song]['1'][:title]
        #    as.save
        #  end
        #end
        format.html { redirect_to action: "show" }
      else
        format.html { render action: "edit" }
      end
    end
  end
  
  def find_by_artist
    @cd = CompactDisk.where
  end
  
  def swap
    @cd = CompactDisk.find(params[:id])
    @user = User.find(@cd.user_id)
    @userCDs = CompactDisk.where(:user_id => @cd.user_id)
    @myCDs = CompactDisk.where(:user_id => current_user.id)
    
  end
  
  # search for a user with a given name
  def self.search(name)
    CompactDisk.where("artist LIKE ? OR title LIKE ? OR genre LIKE ? OR year LIKE ?","%#{name}%","%#{name}%","%#{name}%","%#{name}%")
  end
  
  # Anzeigen aller CDs einez Nutzers + Nutzerinformationen
  def all_user_cds
    @cds = CompactDisk.where(:user_id => params[:id])
    @user = User.find(params[:id])
  end
end

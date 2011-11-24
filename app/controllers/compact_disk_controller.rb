class CompactDiskController < ApplicationController
  load_and_authorize_resource :only => [:show, :destroy]
  
  def index
    @cds = CompactDisk.all
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
  
  def find_by_artist
    @cd = CompactDisk.where
  end
end

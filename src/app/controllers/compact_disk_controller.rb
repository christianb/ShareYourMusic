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
end

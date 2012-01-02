class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :set_i18n_locale_from_params
  before_filter :set_locale
  
  def after_sign_in_path_for(resource)
      stored_location_for(resource) || latest_cd_path
  end
  
  def after_update_path_for(resource)
    user_path(current_user)
  end
  
  def after_sign_out_path_for(resource_or_scope)
    welcome_path
  end
  
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  
    def set_i18n_locale_from_params
      if params[:lcoale]
        if I18n.available_locales.include?(params[:locale].to_sym)
          I18n.locale = params[:locale]
        else
          flash.now[:notice] = "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end
    end
    
    def default_url_options
      { :locale => I18n.locale }
    end
    
    # search for a user with a given name
    def search
      name = params[:querry]
      
      if (!name.empty?)
        #if !name.empty?
      
        # if param is number
        num = name.to_i
        if (num != 0)
          #logger.debug "search num: "+num.to_s
          @cds = CompactDisk.where("cast(year as text) LIKE ?","%#{num}%")
        else
          @songs = Song.where("title LIKE ?","%#{name}%")
          #logger.debug 'songs size = '+@songs.size.to_s
          @cds = CompactDisk.where("artist LIKE ? OR title LIKE ? OR genre LIKE ?","%#{name}%","%#{name}%","%#{name}%")
        end
        @users = User.where("firstname LIKE ? OR lastname LIKE ? OR email LIKE ? OR alias LIKE ?","%#{name}%","%#{name}%","%#{name}%","%#{name}%")
        
        
        
        @songs.each { |s| 
          cd = CompactDisk.where(:id => s.compact_disk_id)
          if cd.length > 0
            #logger.debug 'size cds = '+@cds.length.to_s
            #logger.debug 'title = '+cd.first.title
            #cd.push(@cds)
            
            # if cd is not in array
            if (!@cds.include?(cd.first))
              @cds = @cds.push(cd.first)
            end
            #logger.debug 'size cds = '+@cds.length.to_s
          end
        }

        # delete own cd's
        if (user_signed_in? && !current_user.search_own_cds)
          @cds = @cds.delete_if {|c| c.user_id == current_user.id}
        end
      
        # delete own user
        if (user_signed_in?)
          @users = @users.delete_if {|u| u.id == current_user.id}
        end
      else
        # @Christian S.: Bitte zeigen eine Fehlermeldung an wenn Suchstring leer ist. Danke :)
        redirect_to :back
      end
    end
  
    def impressum
    end
    
    # Abfrage für Autocomplete beim Suchfeld
    def autoCompl
      if params[:term]
          like= "%".concat(params[:term].concat("%"))
          cds_artist = CompactDisk.where("artist like ?", like)
          cds_title = CompactDisk.where("title like ?", like)
          user_first = User.where("firstname like ?", like)
          user_last = User.where("lastname like ?", like)
      else
          cds = CompactDisk.all
          users = User.all
      end
        list_artist = cds_artist.map {|u| Hash[ id: u.id, label: u.artist, name: u.artist]}
        list_title = cds_title.map {|u| Hash[ id: u.id, label: u.title, name: u.title]}
        list_fistname = user_first.map {|u| Hash[ id: u.id, label: u.firstname, name: u.firstname]}
        list_lastname = user_last.map {|u| Hash[ id: u.id, label: u.lastname, name: u.lastname]}
        list = list_title + list_artist + list_lastname + list_fistname
        render json: list
    end
end

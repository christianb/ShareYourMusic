class ApplicationController < ActionController::Base
  protect_from_forgery
  #before_filter :set_i18n_locale_from_params
  before_filter :set_locale
  
  def after_sign_in_path_for(resource)
      stored_location_for(resource) || compact_disk_index_path
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
      @cds = CompactDisk.where("artist LIKE ? OR title LIKE ? OR genre LIKE ? OR year LIKE ?","%#{name}%","%#{name}%","%#{name}%","%#{name}%").paginate(:page => params[:page], :per_page => 9)
      @users = User.where("firstname LIKE ? OR lastname LIKE ? OR email LIKE ? OR alias LIKE ?","%#{name}%","%#{name}%","%#{name}%","%#{name}%").paginate(:page => params[:page], :per_page => 9)
    end
  
end

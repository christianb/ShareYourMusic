class Notifier < ActionMailer::Base
  default :from => "kallisto.rails@gmail.com"

  def registration_confirmation(email, password)  
      @_new_password = password
      mail(:to => email, :subject => "Registered", :from => "kallisto.rails@gmail.com")  
  end
  
  def deletion_confirmation(email)  
      mail(:to => email, :subject => "Your Account has been deleted", :from => "kallisto.rails@gmail.com")  
  end
  
  def deletion_confirmation_compact_disk(email, title, artist)  
      @title = title
      @artist = artist
      mail(:to => email, :subject => "One of your CDs has been deleted", :from => "kallisto.rails@gmail.com")  
  end
  
  def account_upgrade_to_admin(email)
    mail(:to => email, :subject => "Your Account has been upgraded", :from => "kallisto.rails@gmail.com")  
  end
  
  def account_downgrade_to_user(email)
    mail(:to => email, :subject => "Your Account has been downgraded", :from => "kallisto.rails@gmail.com")  
  end
  
  def new_offer(email, nickname)
    @nick = nickname
    mail(:to => email, :subject => "Sie haben ein neues Angebot", :from => "kallisto.rails@gmail.com")  
  end
  
  def delete_transaction(email, name)
    @name = name
    mail(:to => email, :subject => "Tauschangebot geloescht", :from => "kallisto.rails@gmail.com")  
  end
end

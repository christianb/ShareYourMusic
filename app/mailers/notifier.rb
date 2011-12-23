class Notifier < ActionMailer::Base
  default :from => "kallisto.rails@gmail.com"

  def registration_confirmation(email, password)  
      @_new_password = password
      mail(:to => email, :subject => "Registered", :from => "kallisto.rails@gmail.com")  
  end
  
  def deletion_confirmation(email)  
      mail(:to => email, :subject => "Your Account has been deleted", :from => "kallisto.rails@gmail.com")  
  end
end

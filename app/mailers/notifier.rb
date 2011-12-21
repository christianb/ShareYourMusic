class Notifier < ActionMailer::Base
  default :from => "kallisto.rails@gmail.com"

  def registration_confirmation(email, password)  
      @_new_password = password
      mail(:to => email, :subject => "Registered", :from => "kallisto.rails@gmail.com")  
  end
end

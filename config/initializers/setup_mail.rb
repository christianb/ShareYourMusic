ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,  
  :address            => 'smtp.gmail.com',
  :port               => 587,
  :tls                  => true,
  :domain             => 'google.com', #you can also use google.com
  :authentication     => :plain,
  :user_name          => 'kallisto.rails@gmail.com',
  :password           => 'm[;COTKdYA01{^N{:joL:AOKo'
}
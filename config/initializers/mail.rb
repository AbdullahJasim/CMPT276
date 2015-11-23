require 'mail'

Mail.defaults do
  delivery_method :smtp, {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name      => 'app42868944@heroku.com',
    :password       => 'abcq3zwb2406',
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end

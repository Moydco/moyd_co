ActionMailer::Base.smtp_settings = {
    :address   => 'smtp.mandrillapp.com',
    :port      => 587,
    :user_name => Settings.mandrill_username,
    :password  => Settings.mandrill_password,
    :domain    => 'handmade.io'
}
ActionMailer::Base.delivery_method = :smtp

MandrillMailer.configure do |config|
  config.api_key = Settings.mandrill_api_key
end
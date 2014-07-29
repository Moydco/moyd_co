class SubscribeMailer < ActionMailer::Base
  default from: "no-reply@moyd.co"

  def new_subscription(user)
    @user = user
    mail(to: 'hello@moyd.co', subject: 'New user').deliver
  end

  def new_message(first_name, last_name, email ,message)
    @first_name = first_name
    @last_name  = last_name
    @email      = email
    @message    = message
    mail(to: 'hello@moyd.co', subject: 'New message').deliver
  end
end

class SubscribeMailer < ActionMailer::Base
  default from: "no-reply@moyd.co"

  def new_subscription(user)
    @user = user
    mail(to: 'hello@handmade.io', subject: 'New user').deliver
  end

  def new_message(first_name, last_name, email, to ,message)
    @first_name = first_name
    @last_name  = last_name
    @email      = email
    @to         = to
    @message    = message
    mail(to: 'hello@handmade.io', subject: 'New message').deliver
  end
end

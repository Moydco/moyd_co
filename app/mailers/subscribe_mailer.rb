class SubscribeMailer < ActionMailer::Base
  default from: "no-reply@moyd.co"

  def new_subscription(user,message)
    @user = user
    @message = message
    mail(to: 'hello@moyd.co', subject: 'New user').deliver
  end

  def new_message(first_name, last_name, email ,message)
    @first_name = first_name
    @last_name  = last_name
    @email      = email
    @message    = message
    mail(to: 'hello@moyd.co', subject: 'New message').deliver
  end

  def thank_you_subscription(user)
    @user = user
    mail(to: user.email, subject: 'Thank you for your subscription').deliver
  end


  def thank_you_message(user)
    @user = user
    mail(to: user.email, subject: 'Thank you for your message').deliver
  end
end

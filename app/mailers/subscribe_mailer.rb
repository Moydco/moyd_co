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

  def thank_you_subscription(first_name, last_name, email)
    @first_name = first_name
    @last_name  = last_name
    @email      = email
    mail(to: @email, subject: 'Thank you for your subscription').deliver
  end


  def thank_you_message(first_name, last_name, email)
    @first_name = first_name
    @last_name  = last_name
    @email      = email
    mail(to: @email, subject: 'Thank you for your message').deliver
  end

  def credit_card_transaction(invoice, transaction, amount, currency)
    @invoice     = invoice
    @transaction = transaction
    @amount      = amount
    @currency    = currency
    mail(to: 'a.zuin@moyd.co', subject: 'Credit card transaction').deliver
  end

  def suspend_resume_subscription(subscription)
    @subscription = Subscription.find(subscription)
    mail(to: 'a.zuin@moyd.co', subject: 'Subscription Suspended/Resumed').deliver
  end
end

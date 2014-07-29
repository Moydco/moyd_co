class StaticsController < ApplicationController
  require 'json'
  require 'httparty'

  def index
    @user = User.new
    response = Net::HTTP.get_response(URI.parse(Settings.blog_posts_uri))
    response_json = JSON.parse(response.body)
    if not response_json["status"].nil? and response_json["status"].downcase == "ok"
      @post = response_json["posts"].first
    else
      @post = nil
    end
  end

  def create
    if params[:user][:opt_in] == '1'
      @user = User.new(user_attributes)
      if @user.save
        SubscribeMailer.new_subscription(@user,params[:user][:message])
        SubscribeMailer.thank_you_subscription(@user)
        flash[:notice] = @user.first_name.to_s + ', thank you for subscribe'
        redirect_to root_path(anchor: 'contact-top')
      else
        flash[:error] = 'Sorry, something went wrong: ' + @user.errors.full_messages.to_sentence
        redirect_to root_path(anchor: 'contact-top')
      end
    else
      @user=params[:user]
      SubscribeMailer.new_message(@user[:first_name],@user[:last_name],@user[:email],@user[:message])
      SubscribeMailer.thank_you_message(@user)
      flash[:notice] = 'Thank you for your message'
      redirect_to root_path(anchor: 'contact-top')
    end
  end

  private

  def user_attributes
    params.require(:user).permit(:first_name, :last_name, :email, :opt_in, :message)
  end
end

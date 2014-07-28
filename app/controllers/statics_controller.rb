class StaticsController < ApplicationController
  def index
    @user = User.new
  end

  def create
    if params[:opt_in]
      @user = User.new(user_attributes)
      if @user.save
        SubscribeMailer.new_subscription(@user)
        flash[:notice] = @user.first_name.to_s + ', thank you for subscribe'
        redirect_to root_path
      else
        flash[:error] = 'Sorry, something went wrong: ' + subscriber.errors.full_messages.to_sentence
        redirect_to root_path
      end
    else
      @user=params[:user]
      SubscribeMailer.new_message(@user[first_name],@user[:last_name],@user[:email],@user[:message])
      flash[:notice] = 'Thank you for your message'
      redirect_to root_path
    end
  end

  private

  def user_attributes
    params.require(:user).permit(:first_name, :last_name, :email, :opt_in, :to, :message)
  end
end

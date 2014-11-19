class SubscriptionsController < ApplicationController
  def index
    if current_user.admin
      @user = User.find(params[:user_id])
    end
  end

  def edit
    if current_user.admin
      @user = User.find(params[:user_id])
      @subscription = @user.subscriptions.find(params[:id])
    end
  end

  def update
    if current_user.admin
      @user = User.find(params[:subscription][:user_id])
      @subscription = @user.subscriptions.find(params[:id])
      @subscription.update_attributes(subscription_params)
      redirect_to subscriptions_path(user_id: @user.id)
    end
  end

  def new
    if current_user.admin
      @user = User.find(params[:user_id])
      @subscription = @user.subscriptions.new
    end
  end

  def create
    if current_user.admin
      @user = User.find(params[:subscription][:user_id])
      @subscription = @user.subscriptions.create(subscription_params)
      redirect_to subscriptions_path(user_id: @user.id)
    end
  end

  def destroy
    if current_user.admin
      @user = User.find(params[:user_id])
      @subscription = @user.subscriptions.find(params[:id])
    else
      @subscription = current_user.subscriptions.find(params[:id])
    end

    @subscription.update_attribute(:enabled, !@subscription.enabled) unless @subscription.nil?

    SubscribeMailer.suspend_resume_subscription(@subscription)
    redirect_to subscriptions_path(user_id: @user.id)
  end

  private

  def subscription_params
    params.required(:subscription).permit(:product, :description, :rate, :interval, :month, :maintenance, :item_type, :item_quantity, :combinable, :recurring,  :enabled)
  end
end

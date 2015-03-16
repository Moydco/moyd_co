class StaticsController < ApplicationController
  require 'json'
  require 'httparty'

  def hosting
    set_meta_tags :title => 'Professional Hosting Plan'
    set_meta_tags :description => 'Take advantage of Moyd.co worldwide server infrastructure to host your internet application in the most secure way. Now, be the Master Of Your Domain!'
    set_meta_tags :keywords => 'Moyd, moyd.co, master of your domain, customer, professional, hosting, web, mail'
    set_meta_tags :og => {
                      :title => 'Professional Hosting Plan',
                      :description => 'Take advantage of Moyd.co worldwide server infrastructure to host your internet application in the most secure way. Now, be the Master Of Your Domain!'
                  }
  end

  def reseller
    set_meta_tags :title => 'Reseller packages'
    set_meta_tags :description => 'If you are a web designer, a web agency or a SEO consultant, you already know the importance of an high speed secure hosting. Now, be the Master Of Your Domain!'
    set_meta_tags :keywords => 'Moyd, moyd.co, master of your domain, server, reseller, hosting, web, mail'
    set_meta_tags :og => {
                      :title => 'Reseller packages',
                      :description => 'If you are a web designer, a web agency or a SEO consultant, you already know the importance of an high speed secure hosting. Now, be the Master Of Your Domain!'
                  }
  end

  def infrastructure
    set_meta_tags :title => 'Carrier Grade infrastructure'
    set_meta_tags :description => 'Moyd.co has a worldwide server infrastructure to host your internet application in the most secure way. Now, be the Master Of Your Domain!'
    set_meta_tags :keywords => 'Moyd, moyd.co, master of your domain, server, infrastructure, hosting, web, mail'
    set_meta_tags :og => {
                      :title => 'Carrier Grade infrastructure',
                      :description => 'Moyd.co has a worldwide server infrastructure to host your internet application in the most secure way. Now, be the Master Of Your Domain!'
                  }
  end

  def dns
    set_meta_tags :title => 'Cloud Operator DNS Software'
    set_meta_tags :description => 'Moyd.co is the new Cloud Operator Monitor and DNS Server Software with High Availability, Load Balancing and GeoDNS functionality. Now, be the Master Of Your Domain!'
    set_meta_tags :keywords => 'Moyd, moyd.co, master of your domain, DNS, monitor, GeoDNS, Load Balancing, High Availability, GeoDNS, Anycast, server, Cloud, OpenNebula, OpenStack'
    set_meta_tags :og => {
        :title => 'Cloud Operator DNS Software',
        :description => 'Moyd.co is the new Cloud Operator Monitor and DNS Server Software with High Availability, Load Balancing and GeoDNS functionality. Now, be the Master Of Your Domain!'
    }
  end

  def support
    set_meta_tags :title => 'Linux server admin and programming'
    set_meta_tags :description => 'Moyd.co can help your business to plan, install and mantain all your server infrasfructure. Also web and mobile development with the most advanced programming tools.'
    set_meta_tags :keywords => 'Moyd, moyd.co, master of your domain, server, linux, maintenance, administration, programming, ruby on rails, scala, angularjs, java, python, mongodb'
    set_meta_tags :og => {
        :title => 'Linux server admin and programming',
        :description => 'Moyd.co can help your business to plan, install and mantain all your server infrasfructure. Also web and mobile development with the most advanced programming tools.'

    }
  end

  def team
    set_meta_tags :title => 'Meet the dream team'
    set_meta_tags :description => 'Moyd.co has a costantly growing team of system engineering and developer. This is the core team, here to help you!'
    set_meta_tags :keywords => 'Moyd, moyd.co, master of your domain, alberto zuin, manuel zulian, enrico talin, zuin alberto, zulian manule, talin enrico, team'
    set_meta_tags :og => {
        :title => 'Meet the dream team',
        :description => 'Moyd.co has a costantly growing team of system engineering and developer. This is the core team, here to help you!'

    }
  end

  def contact_us
    set_meta_tags :title => 'Contact us'
    set_meta_tags :description => 'You can contact Moyd.co team using this form. If you are a customer, you can have a complete ticket support system to track your request.'
    set_meta_tags :keywords => 'Moyd, moyd.co, master of your domain, contact us, email'
    set_meta_tags :og => {
        :title => 'Contact us',
        :description => 'You can contact Moyd.co team using this form. If you are a customer, you can have a complete ticket support system to track your request.'

    }
    @user = User.new
  end

  def create
    if params[:user].nil?
      flash.now[:error] = 'Sorry, something went wrong: no params found!'
      render :contact_us
    elsif params[:user][:opt_in] == '1'
      @user = User.new(user_attributes)
      if @user.save
        SubscribeMailer.new_subscription(@user,params[:user][:message])
        SubscribeMailer.thank_you_subscription(@user[:first_name],@user[:last_name],@user[:email])
        flash[:notice] = @user.first_name.to_s + ', thank you for subscribe'
        redirect_to root_path
      else
        flash.now[:error] = 'Sorry, something went wrong: ' + @user.errors.full_messages.to_sentence
        render :contact_us
      end
    else
      @user=params[:user]
      SubscribeMailer.new_message(@user[:first_name],@user[:last_name],@user[:email],@user[:message])
      SubscribeMailer.thank_you_message(@user[:first_name],@user[:last_name],@user[:email])
      flash[:notice] = 'Thank you for your message'
      redirect_to root_path
    end
  end

  private

  def user_attributes
    params.require(:user).permit(:first_name, :last_name, :email, :opt_in, :message)
  end
end

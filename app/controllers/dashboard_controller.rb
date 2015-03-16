class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    if @user.admin
      @users = User.where(admin: false)
    else
      # Check presence of QuickBooks token
      token=TokenStorage.where(oauth_provider: 'quickbooks').first
      if token.nil?
        raise 'Accounting software not connected'
      else
        # Connecting to QuickBooks
        access_token = OAuth::AccessToken.new($qb_oauth_consumer, token.access_token, token.access_secret)
        # Get customer details on QuickBooks
        service_customer = Quickbooks::Service::Customer.new
        service_customer.company_id = token.company_id
        service_customer.access_token = access_token
        @customer = service_customer.fetch_by_id(@user.quickbooks_id)
        # Get customer invoices
        service_invoices = Quickbooks::Service::Invoice.new
        service_invoices.company_id = token.company_id
        service_invoices.access_token = access_token
        @invoices = service_invoices.query.entries.find_all{ |e| e.customer_ref.value == @user.quickbooks_id}
        # Connecting to Zendesk
        @zendesk_client = ZendeskAPI::Client.new do |config|
          config.url = Settings.zendesk_url
          config.username = Settings.zendesk_user
          config.token = Settings.zendesk_secret
          config.retry = true
        end
        # Get customer details on QuickBooks using email as key
        @zendesk_user = @zendesk_client.users.search(query: @user.email).first
        # Get customer tickets
        @tickets = @zendesk_client.search(query: 'requester:' + @zendesk_user.id.to_s + ' type:ticket')
      end
    end
  end

  # Pay an invoice via Stripe
  def create
    @user = current_user
    token=TokenStorage.where(oauth_provider: 'quickbooks').first
    if token.nil?
      raise 'Accounting software not connected'
    else
      # Connecting to QuickBooks
      access_token = OAuth::AccessToken.new($qb_oauth_consumer, token.access_token, token.access_secret)
      # Get invoice detail by ID
      service_invoice = Quickbooks::Service::Invoice.new
      service_invoice.company_id = token.company_id
      service_invoice.access_token = access_token
      @invoice = service_invoice.fetch_by_id(params[:invoice])
      # Create a Stripe customer object by email
      customer = Stripe::Customer.create(
          :email => current_user.email,
          :card  => params[:stripeToken]
      )
      # Charge invoice balance
      @charge = Stripe::Charge.create(
          :customer    => customer,
          :amount      => (@invoice.balance * 100).to_i,
          :description => @invoice.doc_number,
          :currency    => @invoice.currency_ref.value
      )

      if @charge.paid
        # Adding a note to the invoice with the payment ID
        @invoice.private_note = @charge.id
        service_invoice.update(@invoice)
        # Send an email to customer
        SubscribeMailer.credit_card_transaction(@invoice.doc_number, @charge.id, @invoice.balance, @invoice.currency_ref.value)
        flash[:notice] = 'Thank you for your payment.'
      else
        flash[:error] = 'Sorry, something went wrong.'
      end
      redirect_to dashboard_index_path
    end
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update(user_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true
      flash[:notice] = 'Password updated.'
    else
      flash[:error] = 'Sorry, something went wrong.'
    end
    redirect_to dashboard_index_path
  end

  private

  def user_params
    params.required(:user).permit(:password, :password_confirmation)
  end

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to dashboard_index_path
end


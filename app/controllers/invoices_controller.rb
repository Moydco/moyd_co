class InvoicesController < ApplicationController
  before_action :authenticate_user!

  def index
    if current_user.admin
      @user = User.find(params[:user_id])
      token=TokenStorage.where(oauth_provider: 'quickbooks').first
      if token.nil?
        raise 'Accounting software not connected'
      else
        access_token = OAuth::AccessToken.new($qb_oauth_consumer, token.access_token, token.access_secret)

        service_customer = Quickbooks::Service::Customer.new
        service_customer.company_id = token.company_id
        service_customer.access_token = access_token
        @customer = service_customer.fetch_by_id(@user.quickbooks_id)

        service_invoices = Quickbooks::Service::Invoice.new
        service_invoices.company_id = token.company_id
        service_invoices.access_token = access_token
        @invoices = service_invoices.query.entries.find_all{ |e| e.customer_ref.value == @user.quickbooks_id}
      end
    end
  end

  def new
    if current_user.admin
      @user = User.find(params[:user_id])
      @invoice = @user.invoices.find(params[:invoice_id])
    end
  end

  def update
    if current_user.admin
      @user = User.find(params[:invoice][:user_id])
      @invoice = @user.invoices.find(params[:id])
      @invoice.invoice.store!(params[:invoice][:invoice])
      @invoice.save
      redirect_to(invoices_path(user_id: @user))
    end
  end

  def destroy
    if current_user.admin
      @user = User.find(params[:user_id])
      @invoice = @user.invoices.find(params[:id])
      @invoice.destroy
      redirect_to(invoices_path(user_id: @user))
    end
  end

  def show
    if current_user.admin
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end
    @invoice = @user.invoices.find(params[:id])
    content = @invoice.invoice.read
    if stale?(etag: content, last_modified: @invoice.updated_at.utc, public: true)
      send_data content, type: @invoice.invoice.file.content_type, disposition: 'inline'
      expires_in 0, public: true
    end
  end
end

class Users::PasswordsController < Devise::PasswordsController
  prepend_before_filter :require_no_authentication
  # Render the #edit only if coming from a reset password email link
  append_before_filter :assert_reset_token_passed, only: :edit

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # Overriding devise model to register the user using the data in QuickBooks
  def create
      token=TokenStorage.where(oauth_provider: 'quickbooks').first
      if token.nil?
        raise 'Accounting software not connected'
      else
        # Connecting to QuickBooks
        access_token = OAuth::AccessToken.new($qb_oauth_consumer, token.access_token, token.access_secret)
        # Getting invoice details by ID
        service_invoice = Quickbooks::Service::Invoice.new
        service_invoice.company_id = token.company_id
        service_invoice.access_token = access_token
        invoice = service_invoice.query.entries.find{ |e| e.doc_number == params[:user][:invoice]}
        if invoice.nil?
          raise 'Invoice not found'
        else
          # Getting customer details using the invoice data
          customer_id = invoice.customer_ref.value

          service_customer = Quickbooks::Service::Customer.new
          service_customer.company_id = token.company_id
          service_customer.access_token = access_token
          customer = service_customer.fetch_by_id(customer_id)
          customer_email = customer.primary_email_address.address
          customer_id = customer.id
          customer_first_name = customer.given_name
          customer_first_name = customer.display_name if customer_first_name.nil? or customer_first_name.blank?

          customer_last_name = customer.family_name
          customer_last_name = customer.display_name if customer_first_name.nil? or customer_last_name.blank?

          if customer_email.nil?
            raise 'You don\'t have an email in our accounting software. Please contact us to update your details'
          else
            # Email found: let's check if user is already present
            user = User.where(email: customer_email).first
            if user.nil?
              # There is no user: auto generate a password
              generated_password = Devise.friendly_token.first(8)
              # Create the user
              user = User.create!(email: customer_email,
                                  password: generated_password,
                                  first_name: customer_first_name,
                                  last_name: customer_last_name,
                                  quickbooks_id: customer_id)
            end
            # Send a reset password email to the user, so the auto-generated password remains unknown
            self.resource = resource_class.send_reset_password_instructions(email: user.email)

            yield resource if block_given?
            if successfully_sent?(resource)
              respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
            else
              respond_with(resource)
            end
          end
        end
      end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    super
  end

  # PUT /resource/password
  def update
    super
  end

  protected

  def after_resetting_password_path_for(resource)
    super(resource)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    super(resource_name)
  end
end

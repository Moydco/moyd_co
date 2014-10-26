class QuickBooksController < ApplicationController
  def index

  end

  def authenticate
    callback = oauth_callback_quick_books_url
    token = $qb_oauth_consumer.get_request_token(:oauth_callback => 'https://moyd.co/quick_books/oauth_callback')
    session[:qb_request_token] = Marshal.dump(token)
    redirect_to("https://appcenter.intuit.com/Connect/Begin?oauth_token=#{token.token}") and return
  end

  def oauth_callback
    logger.debug session[:qb_request_token]
    at = Marshal.load(session[:qb_request_token]).get_access_token(:oauth_verifier => params[:oauth_verifier])
    token_storage = TokenStorage.find_or_create_by(oauth_provider: 'quickbooks')
    token_storage.access_token = at.token
    token_storage.access_secret = at.secret
    token_storage.company_id = params['realmId']
    token_storage.save
  end

  def logout
  end
end

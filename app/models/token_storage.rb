class TokenStorage
  include Mongoid::Document
  field :oauth_provider,            type: String
  field :access_token,              type: String, default: ""
  field :access_secret,             type: String, default: ""
  field :company_id,                type: String, default: ""
  field :token_expires_at,          type: DateTime, default: Time.now + 6.months
  field :reconnect_token_at,        type: DateTime, default: Time.now + 5.months

  def renew
    if self.oauth_provider == 'quickbooks'
      access_token = OAuth::AccessToken.new($qb_oauth_consumer, self.access_token, self.access_secret)
      service = Quickbooks::Service::AccessToken.new
      service.access_token = access_token
      service.company_id = self.company_id
      result = service.renew

      # result is an AccessTokenResponse, which has fields +token+ and +secret+
      # update your local record with these new params
      self.access_token = result.token
      self.access_secret = result.secret
      self.token_expires_at = 6.months.from_now.utc
      self.reconnect_token_at = 5.months.from_now.utc
      self.save!
    end
  end
end

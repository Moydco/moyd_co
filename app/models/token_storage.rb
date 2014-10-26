class TokenStorage
  include Mongoid::Document
  field :oauth_provider,            type: String
  field :access_token,              type: String, default: ""
  field :access_secret,             type: String, default: ""
  field :company_id,                type: String, default: ""
  field :token_expires_at,          type: DateTime, default: Time.now + 6.months
  field :reconnect_token_at,        type: DateTime, default: Time.now + 5.months
end

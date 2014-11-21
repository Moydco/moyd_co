# Development
# QB_KEY = 'qyprdqkbx8SBc7cAadgcrzL2jfLUJO'
# QB_SECRET = 'JoGfp4ESZ6KxYJTqxfRKmmT8WuHYU8EMETwJrILR'

# Production
QB_KEY = 'qyprdYCiudqTtfOWSCd2mPNoduLVtc'
QB_SECRET = 'XQtqDgG116hCC3CUihSHQcdp9cXMrbZWuCZ2qHSe'

$qb_oauth_consumer = OAuth::Consumer.new(QB_KEY, QB_SECRET, {
    :site                 => 'https://oauth.intuit.com',
    :request_token_path   => '/oauth/v1/get_request_token',
    :authorize_url        => 'https://appcenter.intuit.com/Connect/Begin',
    :access_token_path    => '/oauth/v1/get_access_token'
})
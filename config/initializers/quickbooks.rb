# Development
#QB_KEY = 'qyprdXLlPllI3h7t0IBq54Ye9QL43Z'
#QB_SECRET = 'jZjTGCkmSS7tdXJ2kSiVeMGcwTYDgDXPGOB7kKPB'

# Production
QB_KEY = 'qyprdYCiudqTtfOWSCd2mPNoduLVtc'
QB_SECRET = 'XQtqDgG116hCC3CUihSHQcdp9cXMrbZWuCZ2qHSe'

$qb_oauth_consumer = OAuth::Consumer.new(QB_KEY, QB_SECRET, {
    :site                 => 'https://oauth.intuit.com',
    :request_token_path   => '/oauth/v1/get_request_token',
    :authorize_url        => 'https://appcenter.intuit.com/Connect/Begin',
    :access_token_path    => '/oauth/v1/get_access_token'
})
set :stage, :production

set :deploy_to, '/home/moyd.co'
set :tmp_dir, '/home/moyd.co/shared/tmp'
# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
role :app, %w{85.159.208.99}
role :web, %w{85.159.208.99}
role :db,  %w{85.159.208.99}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a has can be used to set
# extended properties on the server.
# server 'example.com', user: 'deploy', roles: %w{web app}, my_property: :my_value

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
set :ssh_options, {
    user: %w(moyd.co),
    forward_agent: false,
    auth_methods: %w(publickey),
    port: 12322
}
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

# fetch(:default_env).merge!(rails_env: :staging)

set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.1.1@moyd.co'
set :rails_env, :production

#load 'deploy/assets'
#require 'capistrano/puma'
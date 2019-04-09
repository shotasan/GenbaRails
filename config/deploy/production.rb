server '52.197.145.124', user: 'app', roles: %w{app db web}
set :ssh_options, keys: '/Users/shota/.ssh/id_rsa'
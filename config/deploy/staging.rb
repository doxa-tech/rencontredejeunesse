role :app, %w{rencontredejeunesse@37.139.9.38}
role :web, %w{rencontredejeunesse@37.139.9.38}
role :db,  %w{rencontredejeunesse@37.139.9.38}

# Define server(s)
server '37.139.9.38', user: 'rencontredejeunesse', roles: %w{web app db}, primary: true

# SSH Options
# See the example commented out section in the file
# for more options.

# ask(:password, nil, echo: false)

set :url, '37.139.9.38'

set :ssl, false

set :ssh_options, {
    forward_agent: true,
    user: 'rencontredejeunesse',
    port: 22
}

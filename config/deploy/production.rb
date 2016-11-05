role :app, %w{rencontredejeunesse@82.196.4.249}
role :web, %w{rencontredejeunesse@82.196.4.249}
role :db,  %w{rencontredejeunesse@82.196.4.249}

# Define server(s)
server '82.196.4.249', user: 'rencontredejeunesse', roles: %w{web app db}, primary: true

# SSH Options
# See the example commented out section in the file
# for more options.

ask(:password, nil, echo: false)

set :ssh_options, {
    password: fetch(:password),
    forward_agent: true,
    user: 'rencontredejeunesse',
    port: 22
}

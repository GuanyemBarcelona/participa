# config valid only for Capistrano 3.4.0
lock '3.4.1'

set :application, 'participa.barcelonaencomu.cat'
set :repo_url, 'https://github.com/GuanyemBarcelona/participa'
set :linked_files, %w{config/database.yml config/secrets.yml config/mailserver.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system db/podemos}

set :user, 'participa'
set :ssh_options, forward_agent: true

after 'deploy:publishing', 'passenger:restart'

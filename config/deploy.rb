require 'bundler/capistrano'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :application, 'chewbacon'
set :domain,      'chewbacon.com'

set :scm, :git
set :repository,  'git@github.com:dpbus/chewbacon.git'
set :rails_env,   'production'

set :user,        'deploy'
set :use_sudo,    false
set :deploy_to,   '/var/www/chewbacon'
set :deploy_via,  :remote_cache

# database options
set :database_username, 'chewbacon'
set :database, application

server fetch(:domain), :app, :web, :db, :primary => true

# callbacks
before 'deploy:setup',       'db:configure'
after  'deploy:setup',       'deploy:setup_config'
after  'deploy:update_code', 'db:symlink'
after  'deploy',             'deploy:check_revision'

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: { no_release: true } do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/conf.d/#{application}.conf"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
  end

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
end

namespace :db do
  desc 'Create database yaml in shared path'
  task :configure do
    set :database_password do
      Capistrano::CLI.password_prompt "Database Password: "
    end
    
    db_config = <<-EOF
production:
  adapter: postgresql
  encoding: utf8
  database: #{database}
  username: #{database_username}
  password: '#{database_password}'
EOF

    run "mkdir -p #{shared_path}/config"
    put db_config, "#{shared_path}/config/database.yml"
    run "chmod 600 #{shared_path}/config/database.yml"
  end

  desc 'Symlink database config'
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end
end

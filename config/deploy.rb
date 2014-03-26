require "bundler/capistrano"

server "linode", :web, :app, :db, primary: true

set :application, "circles_and_squares"
set :user, "deployer"
set :deploy_to, "/home/#{user}/apps/#{application}"
#set :deploy_via, :remote_cache
set :use_sudo, false
set :rails_env, "production" #added for delayed job

set :scm, "git"
set :repository, "git@bitbucket.org:jgaluten/circles.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases
after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"


namespace :deploy do
  task :start do; end
  task :stop do; end
  task :restart, roles: :app, except: {no_release: true} do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/apache.conf /etc/apache2/sites-available/#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse bitbucket/master`
      puts "WARNING: HEAD is not the same as bitbucket/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
  after "deploy", "update_cron"
end

"Restart Apache"
task :restart_apache, roles: :app do
  run "sudo service apache2 restart"
end

"Updating Crontab"
task :update_cron, roles: :app do
  run "cd #{deploy_to}/current && bundle exec whenever -w"
end


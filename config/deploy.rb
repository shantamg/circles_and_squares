lock '3.5.0'

set :application, 'circlez_and_squarez'
set :repo_url, 'git@github.com:shantamg/circles_and_squares.git'
set :rvm_ruby_version, '2.2.2'

set :branch, "master"

set :use_sudo, false

set :scm, :git

set :pty, true

set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/nginx.conf')

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do

  task :restart do
    invoke 'unicorn:reload'
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

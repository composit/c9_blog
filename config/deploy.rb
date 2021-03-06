set :application, "c9_blog"
set :repository,  "git@github.com:composit/c9_blog.git"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :deploy_via, :remote_cache
set :use_sudo, false

require 'capistrano/ext/multistage'
set :stages, %w( staging production )
set :default_stage, 'staging'

require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3-p374'
set :rvm_type, :system

require 'bundler/capistrano'

set :scm, :git

server "murder", :app, :web, :db, :primary => true

unicorn_pid = "#{current_path}/tmp/pids/unicorn.pid"

namespace :deploy do
  task :restart, roles: :app, except: { no_release: true } do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
end

after "deploy:restart", "deploy:cleanup"

after 'deploy:update_code' do
  run "ln -nfs #{deploy_to}/shared/setup_load_paths.rb #{release_path}/config/setup_load_paths.rb"
  run "ln -nfs #{deploy_to}/shared/config/application.yml #{release_path}/config/application.yml"
end

before 'deploy:assets:precompile' do
  run "ln -nfs #{deploy_to}/shared/config/application.yml #{release_path}/config/application.yml"
end

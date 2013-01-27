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
set :rvm_ruby_string, '1.9.2-p290'
set :rvm_type, :system

require 'bundler/capistrano'

set :scm, :git

server "murder", :app, :web, :db, :primary => true

after "deploy:restart", "deploy:cleanup"

after 'deploy:update_code' do
  run "ln -nfs #{deploy_to}/shared/setup_load_paths.rb #{release_path}/config/setup_load_paths.rb"
end

before 'deploy:assets:precompile' do
  run "ln -nfs #{deploy_to}/shared/config/application.yml #{release_path}/config/application.yml"
end

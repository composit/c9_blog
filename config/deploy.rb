set :application, "c9_blog"
set :repository,  "git@github.com:composit/c9_blog.git"
set :user, "root"
set :deploy_to, "/var/www/c9_blog"
ssh_options[:forward_agent] = true

$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
set :rvm_ruby_string, '1.9.2@c9_blog'        # Or whatever env you want it to run in.

set :scm, 'git'
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server "parasites", :app, :web, :db, :primary => true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{current_release}"
  end
end

after 'deploy:update_code' do
  run "ln -nfs #{deploy_to}/shared/setup_load_paths.rb #{release_path}/config/setup_load_paths.rb"

  run "cd #{release_path} && bundle install --without test --without development"
  run "rvm rvmrc trust #{current_release}"
end

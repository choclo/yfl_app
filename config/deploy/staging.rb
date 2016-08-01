#############################################################
#	Application
#############################################################

set :application, "yourflightlog"
set :deploy_to, "/srv/www/stage.yourflightlog.com/public/"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, true
set :scm_verbose, true
set :rails_env, "staging"

#############################################################
#	Servers
#############################################################

set :user, "admin"
set :domain, "stage.yourflightlog.com"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	Subversion
#############################################################

set :scm, :subversion
set :scm_username, 'adamburmister'
set :scm_password, 'jdkthf8a'
set :repository, "http://svn.flog.co.nz/yourflightlog/trunk"
set :ssh_options, { :forward_agent => true }
set :deploy_via, :export

#############################################################
#	Passenger
#############################################################

namespace :deploy do
  desc "set ENV['RAILS_ENV'] for mod_rails (phusion passenger)"
  task :set_rails_env do
    tmp = "#{current_release}/tmp/environment.rb"
    final = "#{current_release}/config/environment.rb"
    run <<-CMD
      echo 'RAILS_ENV = "#{rails_env}"' > #{tmp};
      cat #{final} >> #{tmp} && mv #{tmp} #{final};
    CMD
  end
  after "deploy:finalize_update", "deploy:set_rails_env"

  desc "Create the database yaml file"
  task :after_update_code do
    db_config = <<-EOF
staging:
  adapter: mysql
  host: localhost
  port: 3306
  encoding: utf8
  database: staging_yourflightlog
  username: staging_yfl_db
  password: paraglid3r
    EOF
    
    put db_config, "#{release_path}/config/database.yml"
  
    #########################################################
    # Uncomment the following to symlink an uploads directory.
    # Just change the paths to whatever you need.
    #########################################################
    
    desc "Symlink the upload directories"
    task :before_symlink do
      run "mkdir -p #{shared_path}/uploads"
      run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
    end
  end
  
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc <<-DESC
    Deploy and run pending migrations. This will work similarly to the \
    `deploy' task, but will also run any pending migrations (via the \
    `deploy:migrate' task) prior to updating the symlink. Note that the \
    update in this case it is not atomic, and transactions are not used, \
    because migrations are not guaranteed to be reversible.
  DESC
  task :migrations do
    set :migrate_target, :latest
    update_code
    migrate
    symlink
    restart
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
end

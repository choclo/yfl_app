#############################################################
#	Application
#############################################################

set :application, "yourflightlog"
set :deploy_to, "/srv/www/app.yourflightlog.com/public/"

#############################################################
#	Settings
#############################################################

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :use_sudo, true
set :scm_verbose, true
set :rails_env, "production" 

#############################################################
#	Servers
#############################################################

set :user, "admin"
set :domain, "app.yourflightlog.com"
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#	SVN
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
production:
  adapter: mysql
  host: localhost
  encoding: utf8
  database: production_yourflightlog
  username: yfl_db
  password: paraglid3rpil0t
  port: 3306
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
  
  desc "Fix file permissions"
  task :fix_file_permissions, :roles => [ :app, :db, :web ] do
    sudo "chmod -R g+rw #{current_path}/tmp"
    sudo "chmod -R g+rw #{current_path}/log"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
end

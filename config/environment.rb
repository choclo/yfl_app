RAILS_ENV = "production"
# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.11' unless defined? RAILS_GEM_VERSION

# TODO: Move to external YAML config
UNITS = {
  :meters => "m",
  :feet => "ft",
  :kilometers => "km",
  :miles => "miles",
  :kilometers_per_hour => "kmph",
  :miles_per_hour => "mph",
  :date_gb => "%d/%m/%Y",
  :date_us => "%m/%d/%Y",
  :conversions => {
    :speed => {
      "mph_to_kmph" => 1.609344
    },
    :distance => {
      "miles_to_km" => 1.609344
    },
    :height => {
      "ft_to_m" => 0.3048
    }
  }
}

# TODO: Move to external YAML config
PREFERENCE_DEFAULTS = { 
  :speed_unit => UNITS[:kilometers_per_hour], 
  :distance_unit => UNITS[:kilometers], 
  :height_unit => UNITS[:meters], 
  :time_zone => "UTC", 
  :date_format => "%d/%m/%Y",
  :language => "EN-GB"
}

# Declare a placeholder for the CDN revisions array
CDN_REVISION = {}

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  
  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # You have to specify the <tt>:lib</tt> option for libraries, where the Gem name (<em>sqlite3-ruby</em>) differs from the file itself (_sqlite3_)
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
   config.gem "aws-s3", :lib => "aws/s3"
  #config.gem 'capistrano-ext', :lim => 'capistrano-ext'
  config.gem 'rubyist-aasm', :lib => 'aasm', :source => 'http://gems.github.com' #, :version => '2.0.2'
  config.gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com' #:version => '2.3.6', 
  config.gem 'ym4r', :lib => 'ym4r'
  config.gem 'geokit'
  config.gem 'hoptoad_notifier', :version => '2.2.0'
  config.gem "ruby-openid", :lib => "openid"
  config.gem "rack-openid", :lib => 'rack/openid'
  config.gem 'ssl_requirement'
  config.gem 'haml'
  config.gem 'newrelic_rpm'
  config.gem 'paperclip'
  #config.gem 'delayed_job', :source => 'git://github.com/collectiveidea/delayed_job.git'
  config.gem 'mime-types', :lib => "mime/types", :version => '1.16'
    
  %w(middleware).each do |dir|
    config.load_paths << "#{RAILS_ROOT}/app/#{dir}"
  end
  
  # These cause problems with irb. Left in for reference
  # config.gem 'rspec-rails', :lib => 'spec/rails', :version => '1.1.11'
  # config.gem 'rspec', :lib => 'spec', :version => '1.1.11'

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_yourflightlog_session',
    :secret      => ENV["SECRET_TOKEN"]
  }

  #config.action_controller.relative_url_root = ''

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  config.active_record.observers = :user_observer, :log_entry_observer, :equipment_observer
end

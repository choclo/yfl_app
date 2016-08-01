class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  include RoleRequirementSystem 
  include SslRequirement
    
  helper :all # include all helpers, all the time
  protect_from_forgery
  filter_parameter_logging :password, :password_confirmation
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found if RAILS_ENV == 'production'
  
  before_filter :login_required
  before_filter :redirect_if_not_setup
  before_filter :set_timezone

  protected

  def current_pilot
    current_user.pilot if current_user
  end
  self.send :helper_method, :current_pilot
  
  #---- before filter methods ----
  
  # Automatically respond with 404 for ActiveRecord::RecordNotFound
  def record_not_found
    render :file => File.join(RAILS_ROOT, 'public', '404.html'), :status => 404
  end
    
  # The pilot profile hasn't been setup on the first login.
  # Redirect the user to the pilot profile creation page if they do not have a pilot profile.
  def redirect_if_not_setup
    if logged_in?
        #if current_user.pilot.nil?
        #  logger.info "User #{current_user ? current_user.login : '?'} does not yet have a pilot profile... redirecting to new pilot page"
      redirect_to new_pilots_url if current_user.pilot.nil?
        #else
      redirect_to new_pilots_pilot_licenses_url if !current_user.pilot.nil? && !current_user.pilot.completed_setup?
        #end
    end
  end
  
  def set_timezone
    if logged_in? && current_user.pilot && current_user.pilot.preferences && !current_user.pilot.preferences.time_zone.nil? && !current_user.pilot.preferences.time_zone.empty?
      Time.zone = current_user.pilot.preferences.time_zone
    else
      Time.zone = "UTC"
    end
  end
  
end


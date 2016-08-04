class SessionsController < ApplicationController
#  ssl_required :new, :create, :open_id_authentication if Rails.env == 'production'

  skip_before_filter :verify_authenticity_token, :only => :create
  skip_before_filter :redirect_if_not_setup
  skip_before_filter :login_required
  
  def new
    if logged_in?
      redirect_to pilots_log_entry_index_path
    end
  end
  
  def show
    redirect_to login_path
  end
  
  def create
    logout_keeping_session!
    if using_open_id?
      open_id_authentication
    else
      password_authentication
    end
  end
  
  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(root_path)
  end
  
  def open_id_authentication
    authenticate_with_open_id do |result, identity_url|
      if result.successful? && self.current_user = User.find_by_identity_url(identity_url)
        successful_login
      else
        flash[:error] = result.message || "Sorry no user with that identity URL exists"
        @remember_me = params[:remember_me]
        render :action => :new
      end
    end
  end
  
  protected
  
  def password_authentication
    user = User.authenticate(params[:login], params[:password])
    if user
      self.current_user = user
      successful_login
    else
      note_failed_signin
      @login = params[:login]
      # @email = params[:email]
      @remember_me = params[:remember_me]
      render :action => :new
    end
  end
  
  def successful_login
    new_cookie_flag = (params[:remember_me].to_i == 1)
    handle_remember_cookie! new_cookie_flag
    redirect_back_or_default(root_path)
    #logger.info self.current_user + " logged in successfully"
  end
  
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end

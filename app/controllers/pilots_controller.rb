class PilotsController < ApplicationController
  skip_filter :redirect_if_not_setup, :only => [ :new, :create ]

  def show
    redirect_to :action => :new and return if current_user.pilot.nil?
    redirect_to :action => :edit
  end
  
  def new
    redirect_to :action => :edit if current_user.pilot
        
    @pilot = Pilot.new
    @pilot.starting_log_entry = StartingLogEntry.new
  end
  
  def create
    redirect_to root_url if current_user.pilot
    
    @pilot = Pilot.new(params[:pilot])
    @pilot.user_id = current_user.id

    # New instance of a StartingLogEntry. This will be saved when the pilot is saved.
    starting_log_entry_defaults = {
      :date => DateTime.now,
      :location_id => -1
    }
    @pilot.starting_log_entry = StartingLogEntry.new starting_log_entry_defaults.merge(params[:starting_log_entry])
    
    # Create and populate a new preferences
    @pilot.preferences = Preferences.new PREFERENCE_DEFAULTS
    
    if @pilot.save
      @display_welcome_message = true
      redirect_to new_pilots_pilot_licenses_path
    else
      flash[:error] = "Sorry, there was a problem creating your Pilot Profile. Please check you've entered in all the fields correctly."
      
      render :action => :new
    end
  end
  
  def edit
    @pilot = current_pilot
  end
  
  def update
    @pilot = current_pilot
    if current_pilot.update_attributes(params[:pilot]) && current_pilot.starting_log_entry.update_attributes(params[:starting_log_entry])
      flash[:notice] = "Pilot Profile was successfully updated."
      redirect_to pilots_log_entry_index_path
    else
      flash[:notice] = "Sorry, there was a problem updating your Pilot Profile. Please check you've entered in all the fields correctly."
      render :action => :edit
    end
  end

  # Render the settings page, linking off to pilot settings and display preferences
  def settings
    # render view
  end
end

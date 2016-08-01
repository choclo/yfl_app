class PreferencesController < ApplicationController
  
  before_filter :set_instance_variables
  
  def new
    redirect_to :action => :edit and return
  end
  
  def create
    redirect_to :action => :edit and return
  end
  
  def show
    render :action => :edit and return
  end
  
  def edit
    
  end
  
  def update
    if current_pilot.preferences.update_attributes(params[:preferences])
      flash[:notice] = "Preferences saved successfully."
      redirect_to :action => :edit
    else
    end
  end

  private
  
  def set_instance_variables
    @speed_units = [["km/h - km per hour", UNITS[:kilometers_per_hour]], ["mph - miles per hour", UNITS[:miles_per_hour]]]
    @distance_units = [["kilometers", UNITS[:kilometers]], ["miles", UNITS[:miles]]]
    @height_units = [["meters", UNITS[:meters]], ["feet", UNITS[:feet]]]
    @date_formats = [["dd/mm/yyyy", UNITS[:date_gb]], ["mm/dd/yyyy", UNITS[:date_us]]]
  end
end

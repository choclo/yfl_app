class LogEntryController < ApplicationController
  
  before_filter :prompt_for_aircraft_type_if_required, :only => [ :new ]
  #before_filter :set_instance_variables_for_log_entry, :only => [ :show, :new, :edit ]

  # The restricted list of attributes to return to API requests for Users
  RESPONSE_ATTR_LIST = [ :id, :name, :email ]
  
  def index
    # Get a paged list of all log entries for this pilot
    # TODO: Page result set

    @total_number_of_flights = current_pilot.log_entries.sum('number_of_flights')
    @total_air_time = current_pilot.log_entries.sum('air_time')
    
    respond_to do |format| 
      format.html {
        # render HTML template
        @log_entries = current_pilot.log_entries.paginate(:select => "id, date, location_id, number_of_flights, air_time", :include => [ :location ], :order => "type ASC, date DESC, created_at DESC", :page => params[:page])
      }
      format.xml {
        @log_entries = current_pilot.log_entries.find(:select => "id, date, location_id, number_of_flights, air_time", :include => [ :location ], :order => "type ASC, date DESC, created_at DESC")
        render :xml => @log_entries.to_xml#(:only => RESPONSE_ATTR_LIST)
        # TODO : Use XML builder or :only to set order and content
      }
      format.json {
        @callback = params[:callback]
        # render JSON template
        # TODO
      }
      format.csv {
        # render CSV template
        # TODO
      }
    end
  end
  
  def show
    set_instance_variables_for_log_entry
    
    @log_entry = current_pilot.log_entries.find(params[:id])
    
    if not @log_entry.location.nil?
      @map = GMap.new("mapContainer")
      @map.control_init(:large_map => true, :map_type => true)
      @map.add_map_type_init(GMapType::G_PHYSICAL_MAP, false)
      @map.add_map_type_init(GMapType::G_NORMAL_MAP)
      @map.add_map_type_init(GMapType::G_HYBRID_MAP)
      @map.set_map_type_init(GMapType::G_PHYSICAL_MAP)
      
      marker = GMarker.new([@log_entry.location.lat, @log_entry.location.lng], :title => @log_entry.location.name, :info_window => "<div class=\"locationMessage\"><h3><a href=\"#{url_for pilots_location_path(@log_entry.location)}\">#{@log_entry.location.name}</a></h3></div>")
      group = GMarkerGroup.new(true, [marker])
      @map.overlay_global_init(group, "flyingSiteLocations")
      
      @map.center_zoom_init([@log_entry.location.lat, @log_entry.location.lng], 14)
    end
  end

  def new
    set_instance_variables_for_log_entry
    
    @log_entry = current_pilot.log_entries.new
    @log_entry.equipment.build
    @log_entry.flight_types.build
    @log_entry.launch_types.build
    @log_entry.wind_directions.build
    @log_entry.aircraft_type = @aircraft_type_of_entry
  end

  def create
    @log_entry = current_pilot.log_entries.new(params[:log_entry])
    
    # Save the pilots current licenses along with this flight on creation
    @log_entry.licenses << current_pilot.licenses
    
    if @log_entry.save
      redirect_to pilots_log_entry_index_path
    else
      #flash[:error] = "Sorry, there were some problems saving your log entry. Please check you've entered in all the fields correctly."
      
      set_instance_variables_for_log_entry
      render :action => :new
    end
  end

  def edit
    @log_entry = current_pilot.log_entries.find(params[:id])
    @aircraft_type_of_entry = @log_entry.aircraft_type
    
    set_instance_variables_for_log_entry
  end
  
  def update
    @log_entry = current_pilot.log_entries.find(params[:id])
    if @log_entry.update_attributes(params[:log_entry])
      flash[:notice] = "Flight Log Entry updated successfully."
      redirect_to pilots_log_entry_path(params[:id])
    else
      flash[:error] = "Sorry, there were some problems saving your log entry. Please check you've entered in all the fields correctly."
      
      set_instance_variables_for_log_entry
      render :action => :edit
    end
  end
  
  def destroy
    @log_entry = current_pilot.log_entries.find(params[:id])
    flash[:notice] = "Flight Log Entry deleted successfully."
    @log_entry.destroy
    redirect_to pilots_log_entry_index_path
  end
  
  def export
    # Render help page
  end
  
  private

  def prompt_for_aircraft_type_if_required
    # If the pilot has licenses for more than one type of aircraft, then ask which
    # type of aircraft they're entering a record for. This will affect what data
    # (like equipment, flight type, launch type) is displayed on the entry page.    

    if !params.nil? && !params['aircraft_type_id'].nil?
      @aircraft_type_of_entry = AircraftType.find(params['aircraft_type_id'])
    elsif !current_pilot.licenses.empty? && !current_pilot.can_fly_many_aircraft_types
      @aircraft_type_of_entry = current_pilot.licenses.first.aircraft_type
    end
    
    # Display prompt for aircraft type
    if @aircraft_type_of_entry.nil?
      if current_pilot.licenses.empty?
        @aircraft_types = AircraftType.all
      else
        @aircraft_types = current_pilot.flyable_aircraft_types
      end
      render :action => :prompt_for_aircraft_type
    end
  end
  
  def set_instance_variables_for_log_entry
    @launch_types = LaunchType.find_all_by_aircraft_type_id(@aircraft_type_of_entry)
    @flight_types = FlightType.find_all_by_aircraft_type_id(@aircraft_type_of_entry)
    @equipment_categories = EquipmentCategory.all#.find_all_by_aircraft_type_id(@aircraft_type_of_entry)
  end
end

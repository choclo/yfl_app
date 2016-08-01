class LocationsController < ApplicationController
  include GeoKit::Geocoders

  DEFAULT_MAP_HEIGHT = 350
  
  def index
    @locations = current_pilot.locations.paginate(:order => "name ASC", :page => params[:page])
    @map_height = DEFAULT_MAP_HEIGHT
    @map = generate_map_for_locations(@locations, 5)
  end
  
  def show
    @location = current_pilot.locations.find(params[:id])
    @map_height = 200
    @map = generate_map_for_location(@location, 12)
  end
  
  def new
    @location = current_pilot.locations.new
  end
  
  def create
    @location = current_pilot.locations.new(params[:location])
    
    if params[:btnLocate]
      # User has requested us to locate the address
      
      # Remember any form changes that have taken place
      @location.attributes = params[:location]
      
      address_parts = []
      address_parts << params[:location][:address1] if not params[:location][:address1].blank?
      address_parts << params[:location][:address2] if not params[:location][:address2].blank?
      address_parts << params[:location][:address3] if not params[:location][:address3].blank?
      address_parts << params[:location][:country] if not params[:location][:country].blank?
      
      # Lookup the address
      loc = geocode(address_parts.join(", "))
      
      if loc.success
        @location.lat, @location.lng = loc.lat, loc.lng
        flash[:notice] = "Found it! The geocoder found coordinates for the address \"#{address_parts.join ', '}\"."
      else
        flash[:notice] = "Sorry, no coordinates were found matching that address. Please modify the address details and try again."
        logger.info loc.to_yaml
      end
      
      @map = generate_map_for_location(@location, 4, true)
      
      render :action => :new
    else
      # Save the model
      if @location.save
        redirect_to pilots_location_path(@location)
      else
        flash[:error] = "Sorry, there were some problems saving your location. Please check you've entered in all the fields correctly."
        render :action => :new
      end
    end
  end
  
  def edit
    @location = current_pilot.locations.find(params[:id])
    @map = generate_map_for_location(@location, 9, true)
  end
  
  def update
    @location = current_pilot.locations.find(params[:id])
    
    if params[:btnLocate]
      # User has requested us to locate the address
      
      # Remember any form changes that have taken place
      @location.attributes = params[:location]
      
      address_parts = []
      address_parts << params[:location][:address1] if not params[:location][:address1].blank?
      address_parts << params[:location][:address2] if not params[:location][:address2].blank?
      address_parts << params[:location][:address3] if not params[:location][:address3].blank?
      address_parts << params[:location][:country] if not params[:location][:country].blank?
      
      # Lookup the address
      loc = geocode(address_parts.join(", "))
      
      if loc.success
        @location.lat, @location.lng = loc.lat, loc.lng
        flash[:notice] = "Found it! The geocoder found coordinates for the address \"#{address_parts.join ', '}\"."
      else
        flash[:notice] = "Sorry, no coordinates were found matching that address. Please modify the address details and try again."
        logger.info loc.to_yaml
      end
      
      @map = generate_map_for_location(@location, 4, true)
      
      render :action => :edit
    else
      # Save the model
      if @location.update_attributes(params[:location])
        flash[:notice] = "Location updated successfully."
        redirect_to pilots_location_path(@location)
      else
        flash[:error] = "Sorry, there were some problems saving your flying site location. Please check you've entered in all the fields correctly."
        @map = generate_map_for_location(@location, 4, true)
        render :action => :edit
      end
    end
  end
  
  def destroy
    @location = current_pilot.locations.find(params[:id])
    flash[:notice] = "Location \"#{@location.name}\" was deleted."
    @location.destroy
    redirect_to pilots_locations_path
  end

  private
  
  def geocode(address)
    MultiGeocoder.geocode(address)
  end

  # Generate a google map for the location
  def generate_map_for_location(location, zoom = 4, is_edit = false)
    return nil if location.lat.nil? || location.lng.nil?
    
    # Create a new map
    map = init_map
    map.center_zoom_init([location.lat, location.lng], zoom)
    
    # Add a marker for this location
    marker_options = { :title => location.name, :clickable => true }
    if is_edit
      marker_options = marker_options.merge({ :draggable => "true", :info_window => "<div class=\"locationMessage\">
<h3>#{location.name}</h3>
<p>The geocoder thinks these are the correct coordinates for this location.</p>
<p>If it's got it wrong you can drag this marker into the correct location, <br />then click the \"Save Location\" button to save the changes.</p></div>" }) 
    else
      marker_options = marker_options.merge({ :info_window => "<div class=\"locationMessage\"><h3>#{location.name}</h3></div>" }) 
    end
    
    marker = GMarker.new( [location.lat, location.lng], marker_options )
    map.declare_init(marker, "flyingSiteLocation")
    map.overlay_init(marker)
    map.event_init(marker, :dragend, "function(){ updateLocationCoordinates(flyingSiteLocation.getLatLng()); }")
    
    return map
  end
  
  # Generate a google map with markers for all locations in the locations array
  def generate_map_for_locations(locations, zoom = 4)
    # Create a new map
    map = init_map
    map.center_zoom_init([locations[0].lat, locations[0].lng], zoom) if not locations.empty?
    
    markers = []
    
    locations.each do |loc|
      if not (loc.lat.nil? || loc.lat.blank? || loc.lng.nil? || loc.lng.blank?)
        markers << GMarker.new([loc.lat, loc.lng], :title => loc.name, :info_window => "<div class=\"locationMessage\"><h3><a href=\"#{url_for :action => :show, :id => loc.id}\">#{loc.name}</a></h3></div>")
      end
    end

    group = GMarkerGroup.new(true, markers)
    map.overlay_global_init(group, "flyingSiteLocations")
    map.record_init group.center_and_zoom_on_markers
    
    return map
  end
  
  def init_map
    # Create a new map
    map = GMap.new("mapContainer")
    map.control_init(:large_map => true, :map_type => true)
    map.add_map_type_init(GMapType::G_PHYSICAL_MAP, false)
    map.add_map_type_init(GMapType::G_NORMAL_MAP)
    map.add_map_type_init(GMapType::G_HYBRID_MAP)
    map.set_map_type_init(GMapType::G_PHYSICAL_MAP)
    return map
  end
end

class LicenseController < ApplicationController
  skip_before_filter :redirect_if_not_setup
  
  def new
    @aircraft_type = nil
    begin 
      @aircraft_type = AircraftType.find(params[:aircraft_type_id])
    rescue
      @aircraft_type = AircraftType.first
    end
    
    @country = params[:country] || current_pilot.country
    
    @license = current_pilot.licenses.new :country => @country, :aircraft_type => @aircraft_type
    
    @licenses = License.find_all_by_aircraft_type_id_and_country(@aircraft_type.id, @country)

    # Render
    flash.clear
  end
  
  def create
    @license = current_pilot.licenses.new(params[:license])
    
    if @license.save
      current_pilot.pilot_licenses.create :license_id => @license.id
      
      redirect_to pilots_pilot_licenses_path
    else
      flash[:error] = "Sorry, there were some problems saving your license. Please check you've entered in all the fields correctly."
      render :action => :new
    end
    
  end

  def edit
    @license = License.find(params[:id])
    raise "You are not authorised to edit this license" if @license.nil? || @license.pilot_id != current_pilot.id
  end
  
  def update
    @license = current_pilot.licenses.find(params[:id])
    raise "You are not authorised to edit this license" if @license.nil?
    
    if @license.update_attributes(params[:license])
      flash[:notice] = "License updated successfully."
      redirect_to pilots_pilot_licenses_path
    else
      flash[:error] = "Sorry, there were some problems saving your license. Please check you've entered in all the fields correctly."
      render :action => :edit
    end
  end
  
  def destroy
    @license = current_pilot.licenses.find(params[:id])
    raise "You are not authorised to edit this license" if @license.nil?
    
    if @license.destroy
      flash[:notice] = "License deleted."
      redirect_to pilots_pilot_licenses_path
    else
      flash[:error] = "Sorry, there was a problem deleting this license. Please try again."
      render :action => :edit
    end
  end
  
end

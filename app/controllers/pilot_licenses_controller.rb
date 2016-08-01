class PilotLicensesController < ApplicationController
  skip_before_filter :redirect_if_not_setup
  
  def index
    
  end
  
  def new
    # @aircraft = AircraftType.find(params[:aircraft_id])
    # @country = params[:country] || current_pilot.country
    # @licenses = License.find(:all, :conditions => [ "(aircraft_type_id = :aircraft_id AND country = :country AND pilot_id is null) OR (aircraft_type_id = :aircraft_id AND pilot_id = :pilot_id)", { :aircraft_id => @aircraft.id, :country => @country, :pilot_id => current_pilot.id } ])
    # # Render
    # flash.clear
  end
  
  def create
    license_ids = params[:licenses] || []
    
    begin
      PilotLicense.transaction do
        current_pilot.pilot_licenses.destroy_all
                
        license_ids.each do |license_id|
          current_pilot.pilot_licenses.create :license_id => license_id
        end
        
        # If this was the first run through then mark the pilot as completely setup
        if !current_pilot.completed_setup?
          current_pilot.completed_setup = true 
          current_pilot.save
        end
        
        redirect_to '/' #pilots_log_entry_index
      end
    rescue #ActiveRecord::Rollback
      flash[:error] = "Sorry, there was a problem updating your licenses. Please try again."
      redirect_to :back
    end
  end
  
  def edit
    
  end
  
  def update
    license_ids = params[:licenses] || []
    
    # AB: REMOVED: Don't be too strict. Allow users to skip over this - we don't really need it for the to continue.
    #if license_ids.nil? || license_ids.empty?
    #  flash[:error] = "You must select at least 1 pilot license."
    #  redirect_to :back and return
    #end
    
    begin
      PilotLicense.transaction do
        current_pilot.pilot_licenses.destroy_all
                
        license_ids.each do |license_id|
          current_pilot.pilot_licenses.create :license_id => license_id
        end
        
        # If this was the first run through then mark the pilot as completely setup
        if !current_pilot.completed_setup?
          current_pilot.completed_setup = true 
          current_pilot.save
        end
        
        redirect_to pilots_settings_path
      end
    rescue #ActiveRecord::Rollback
      flash[:error] = "Sorry, there was a problem updating your licenses. Please try again."
      redirect_to :back
    end
  end
  
end

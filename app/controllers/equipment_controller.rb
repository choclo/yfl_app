class EquipmentController < ApplicationController
    
  # def category_index
  #   
  # end

  def show
    # if params.has_key?(:equipment_category_slug) && params.has_key?(:equipment_slug) && params.has_key?(:aircraft_type_slug)
    #   @equipment = current_pilot.equipment.find(:first, :conditions => { :slug => params[:equipment_slug] })
    # else
    #   begin
    #     # If there is an ID passed load by ID
    #     Integer(params[:id])
    #     @equipment = current_pilot.equipment.find(params[:id])
    #   rescue
    #     # Not an integer
    #     cat = EquipmentCategory.find_by_slug(params[:id])
    #     @equipment = current_pilot.equipment.find_by_equipment_category_id(cat)
    #     render :action => :category_index and return
    #   end
    # end
    @equipment = Equipment.find(:first, :conditions => { :pilot_id => current_pilot.id, :id => params[:id] })
  end
  
  def new
    # if params.has_key?(:aircraft_type_slug) && params.has_key?(:equipment_category_slug)
    #   logger.info "New equipment for specific category and aircraft type"
    #   @prompt_for_category_and_aircraft = false
    #   aircraft_type = AircraftType.find_by_slug(params[:aircraft_type_slug])
    #   ec = EquipmentCategory.find(:first, 
    #           :conditions => { 
    #             :slug => params[:equipment_category_slug], 
    #             :aircraft_type_id => aircraft_type.id
    #           }
    #         )
    #   @equipment = current_pilot.equipment.new
    #   @equipment.equipment_category = ec
    #   @equipment.aircraft_type_ids = [ aircraft_type.id ]
    # else
    #   logger.info "New equipment for unknown category and aircraft type"
    #   @prompt_for_category_and_aircraft = true
    #   @equipment = current_pilot.equipment.new
    # end
    @equipment = current_pilot.equipment.new
  end
  
  def create
    @equipment = current_pilot.equipment.new(params[:equipment])
    
    if @equipment.save
      # redirect_to pilots_aircraft_equipment_category_equipment_path(
      #     :aircraft_type_slug => (@equipment.aircraft_types.length == 1 ? @equipment.aircraft_types[0].slug : "shared"), 
      #     :equipment_category_slug => @equipment.equipment_category.slug, 
      #     :equipment_slug => @equipment.slug
      #   )
      redirect_to pilots_equipment_index_path
    else
      flash[:error] = "Sorry, there were some problems saving your log entry. Please check you've entered in all the fields correctly."
      render :action => :new
    end
  end
  
  def edit
    @equipment = current_pilot.equipment.find(params[:id])
  end
  
  def update
    @equipment = current_pilot.equipment.find(params[:id])
    
    if @equipment.update_attributes(params[:equipment])
      flash[:notice] = "#{@equipment.name} updated successfully."
      redirect_to pilots_equipment_index_path
      # @equipment_slug et al are set in find_equipment_by_slugs_or_id
      # redirect_to pilots_aircraft_equipment_category_equipment_path(
      #           :aircraft_type_slug => @aircraft_type_slug, 
      #           :equipment_category_slug => @equipment_category_slug, 
      #           :equipment_slug => @equipment_slug
      #         )
    else
      flash[:error] = "Sorry, there were some problems saving your equipment. Please check you've entered in all the fields correctly."
      render :action => :edit
    end
  end

  def destroy
    @equipment = current_pilot.equipment.find(params[:id])
    @equipment.deleted = true
    @equipment.save
    #@equipment.destroy
    flash[:notice] = "Equipment deleted successfully."
    redirect_to pilots_equipment_index_path
  end
  
  def restore
    @equipment = Equipment.find(:first, :conditions => { :pilot_id => current_pilot.id, :id => params[:id] })
    @equipment.deleted = false
    @equipment.save
    
    flash[:notice] = "Done! You have successfully undeleted this piece of equipment."
    redirect_to pilots_equipment_path(@equipment)
  end
  
  private
  
  # Find the equipment item by the passed slugs or ids
  # Since there are two ways of accessing the same content, via computer friendly IDs and
  # human friendly URLs
  # def find_equipment_by_slugs_or_id
  #   if params.has_key?(:equipment_slug) && params.has_key?(:equipment_category_slug)
  #     logger.info "Finding equipment by slugs"
  #     equipment = current_pilot.equipment.find(:first, 
  #         :conditions => {
  #         :slug => params[:equipment_slug],
  #         :equipment_category_id => EquipmentCategory.find_by_slug(params[:equipment_category_slug]).id
  #       }
  #     )
  #   else
  #     logger.info "Finding equipment by id"
  #     equipment = current_pilot.equipment.find(params[:id])
  #   end
  #   
  #   if equipment
  #     @equipment_slug = equipment.slug
  #     @equipment_category_slug = equipment.equipment_category.slug
  #     @aircraft_type_slug = (equipment.aircraft_types.length == 1 ? equipment.aircraft_types[0].slug : "shared")
  #   end
  #   
  #   return equipment
  # end
  
end

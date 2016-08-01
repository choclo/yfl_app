module EquipmentCategoryHelper

	# Build up a list of equipment categories by aircraft type
	def options_for_equipment_categories(options = {})
		selected_category_id = options[:selected] || nil
		
		options_html = ""
		
		for d in equipment_categories_collection 
			options_html += "<optgroup label=\"#{d[1][:label]}\">"
			options_html += options_for_select d[1][:categories], selected_category_id
			options_html += "</optgroup>"
		end
		
		options_html
	end

	# Return a hash of categories for aircraft types
	# e.g.
	# {
	#		-1 => {
	#			 :label => "Shared equipment",
	#			 :categories => [ ["name", 0], ["name", 1] ]
	#		},
	#		1 => {
	#			 :label => "Paraglider",
	#			 :categories => [ ["name", 0], ["name", 1] ]
	#		}
	# }
	#
	# data[1][:label] = "Paraglider"
	def equipment_categories_collection
		shared_equipment_string = "Shared equipment"
		
		pilots_flyable_aircraft_types = current_pilot.flyable_aircraft_types || []
		
		# Create the data hash, insert the shared equipment hash
		data = {
			-1 => {
				:label => shared_equipment_string,
				:categories => []
			}
		}
		# Append hashes for each type of aircraft
		for aircraft in AircraftType.all do 
			data.store(aircraft.id, {
					:label => aircraft.name,
					:categories => []
				}
			)
		end

		for category in EquipmentCategory.find(:all, :order => "display_order DESC, name ASC") do
			# If the pilot can fly many aircraft, and this equipment category doesn't belong to one of those aircraft types, then skip it
			if (pilots_flyable_aircraft_types != []) && (category.aircraft_types & pilots_flyable_aircraft_types == [])
				next
			end
			
			if category.aircraft_types.length == 1
				# Unique to one type of aircraft
				data[category.aircraft_types[0].id][:categories] << [ category.name, category.id ]
			else
				# Shared between different types of aircraft
				data[-1][:categories] << [ category.name, category.id ]
			end
		end
		
		return data.sort
	end
end
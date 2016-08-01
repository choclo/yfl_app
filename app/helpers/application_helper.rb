module ApplicationHelper
  
  # Sets the page title and outputs title if container is passed in.
  # eg. <%= title('Hello World', :h2) %> will return the following:
  # <h2>Hello World</h2> as well as setting the page title.
  def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
  end
  
  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << "<div class=\"messageBox flash-#{msg}\"><img src=\"/images/flash/#{msg}.png\" alt=\"#{msg}\" class=\"icon\" />#{html_escape(flash[msg.to_sym])}</div>" unless flash[msg.to_sym].blank?
      
      #content_tag(:div, content_tag(:span, html_escape(flash[msg.to_sym]), :class => "m"), :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end
  
  def current_navigation_tab(primary_nav, secondary_nav)
    @current_primary_navigation = primary_nav
    @current_secondary_navigation = secondary_nav
    # current_navigation_tab :flight_log, :index
    nil
  end
  
  # Rounds a decimal to some precision and strips any trailing ".0" from the string
  # Example:
  #   pretty_decimal(10.256, 1) --> 10.3
  #   pretty_decimal(10.99, 1) --> 11
  def pretty_decimal(d, precision = 1)
    begin
      d = d.round(precision)
      format = "%.#{(d % 1 == 0) ? 0 : precision}f"
      stripped = format % d
      return stripped
    rescue
      return d
    end
  end
  
  def format_minutes_as_hours_or_minutes(mins, short = false)
    if mins > 60
      hours = mins / 60.00
      "#{pretty_decimal(hours)} #{(hours == 1 ? (short ? 'hr' : 'hour') : (short ? 'hrs' : 'hours'))}"
    else
      "#{pretty_decimal(mins)} #{(mins == 1 ? (short ? 'min' : 'minute') : (short ? 'mins' : 'minutes'))}"
    end
  end

  #---- Unit Preference conversion method ----
  
  # Return a human readable version of the users preferred unit for speed
  def speed_unit
    return "km/h" if current_user.pilot.preferences.speed_unit == UNITS[:kilometers_per_hour]
    return "mph" if current_user.pilot.preferences.speed_unit == UNITS[:miles_per_hour]
    return current_user.pilot.preferences.speed_unit
  end
  
  # Return a human readable version of the users preferred unit for distance
  def distance_unit
    return current_user.pilot.preferences.distance_unit
  end
  
  # Return a human readable version of the users preferred unit for height
  def height_unit
    return "meters" if current_user.pilot.preferences.height_unit == UNITS[:meters]
    return "feet" if current_user.pilot.preferences.height_unit == UNITS[:feet]
    return current_user.pilot.preferences.height_unit
  end
  
  # Convert from kmph to the users preferred unit for speed
  def in_user_speed_units(val)
    if current_user.pilot.preferences.speed_unit == UNITS[:miles_per_hour]
      return val / UNITS[:conversions][:speed]["mph_to_kmph"]
    end
    val 
  end
  
  # Convert from km to the users preferred unit for distance
  def in_user_distance_units(val)
    if current_user.pilot.preferences.distance_unit == UNITS[:miles]
      return val / UNITS[:conversions][:distance]["miles_to_km"]
    end
    val
  end
  
  # Convert from m to the users preferred unit for height
  def in_user_height_units(val)
    if current_user.pilot.preferences.height_unit == UNITS[:feet]
      return val / UNITS[:conversions][:height]["ft_to_m"]
    end
    val
  end

end

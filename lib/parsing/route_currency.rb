# # Module to determine whether a route is current.
module PARSE_ROUTE_CURRENCY

  # ## Method to determine whether a route is current.
  def parse_route_currency( route_id )
    
    # If the route is current...
    if current_route?( route_id )

      # ... we update the route current attribute to TRUE.
      update_route_hash( route_id, 'TRUE', nil, nil, nil )

    # Otherwise, if the route is not current ...
  else

      # ... we update the route current attribute to FALSE and the route status attribute to UNTRAVERSABLE.
      # Setting the route status to UNTRAVERSABLE records that the route is not currently traversable - and is used to infer that routes which follow this route are also not currently traversable.
      # We also record this route as parsed because we don't want to visit it and attempt to parse again.
      update_route_hash( route_id, 'FALSE', 'UNTRAVERSABLE', true, nil )
    end
  end


  # ## A method to show if a route is current.
  # We call the method with the ID of the route.
  # A route may have start and end dates.
  def current_route?( route_id )
    start_date = @routes[route_id][:route].start_date
    end_date = @routes[route_id][:route].end_date
  
    # If the route has a start date and the start date is in the future, being today or after today ...
    if start_date and start_date > Date.today
    
      # .. we set current to false.
      current = false
    
    # Otherwise, if the route has an end date and the end date is in the past, being earlier than today ...
    elsif end_date and end_date < Date.today
    
      # ... we set current to false.
      current = false
    
    # Otherwise, if the route has no start date or a start date in the past or no end date or an end date in the future ...
    else
    
      # ... we set current to true.
      current = true
    end
  
    # We return the value we've set for the route's currency.
    current
  end
end
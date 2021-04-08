# # Module to determine whether a route is currently traversible.
module PARSE_ROUTE_CURRENCY

  # ## Method to determine whether a route is currently traversible.
  def parse_route_currency( route )
    
    # A route has optional start and end dates.
    # A non-current route is one with a start date that is later than today or one with an end date of today or earlier than today.
    # If the route is current...
    if route.current

      # ... we update the route current attribute to true.
      update_route_hash( route, 'TRUE', nil, nil, nil, nil, nil, nil, nil )

    # Otherwise, if the route is not current ...
    else

      # ... we update the route current attribute to 'FALSE' and the route status attribute to 'UNTRAVERSABLE' ...
      # ... setting the route status to 'UNTRAVERSABLE' records that this route is not currently traversible and is used to infer that routes from this route are also not currently traversible.
      # ... we also record this route as parsed because we don't want to visit it and attempt to parse again.
      update_route_hash( route, 'FALSE', 'UNTRAVERSABLE', true, nil, nil, nil, nil, nil )
    end
  end
end
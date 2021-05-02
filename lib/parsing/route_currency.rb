# # Module to determine whether a route is current.
module PARSE_ROUTE_CURRENCY

  # ## Method to determine whether a route is current.
  def parse_route_currency( route_id )
    
    # If the route is current...
    if route_is_current?( route_id )

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
end
module PARSE_ROUTE_CURRENCY
  
  def parse_route_currency( route )


    # ### We check for route currency.

    # A non-current route is one with a start date that is later than today or one with an end date that is today or earlier than today.
    # If the route is current...
    if route.current

      # ... we update the route current attribute to true.
      update_route_hash( route, 'TRUE', nil, nil, nil, nil, nil, nil, nil )

    # ... otherwise, if the route is not current ...
    else

      # ... we update the route current attribute to 'FALSE' and the route status attribute to 'UNTRAVERSABLE' ...
      # ... setting the route status to 'UNTRAVERSABLE' records that this route in not currently active and is used to infer that routes from this route are also not currently active.
      # ... we also record this route as parsed because we don't want to visit it and attempt to parse again.
      update_route_hash( route, 'FALSE', 'UNTRAVERSABLE', true, nil, nil, nil, nil, nil )
    end
  end
end
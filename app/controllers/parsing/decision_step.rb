module PARSING_DECISION_STEP
  
  def parse_route_from_decision_step( route, source_step, procedure, inbound_routes )
  
    # If the decision step does not have one and only one inbound route ...
    if inbound_routes.size != 1
  
      # ... flag the step has an unexpected number of routes.
      logger.error "Decision step with ID #{source_step.id} has #{inbound_routes.size} inbound routes."
  
    # Otherwise, if the decision step has one and only one inbound route ...
    else
  
      # If the inbound route has been parsed ....
      if @routes[inbound_routes[0]][:parsed] == true
        
        # ... update the parse log.
        @parse_log << 'Parsed'
    
        # ... set the parsed attribute to true because this route will be parsed.
        update_route_hash( route, nil, nil, true, nil, nil, nil, nil )
        
        # ... if the inbound route has a status of 'TRUE'
        if @routes[inbound_routes[0]][:status] == 'TRUE'
        
          # ... set the route status to 'ALLOWS'
  				update_route_hash( route, nil, 'ALLOWS', nil, nil, nil, nil, nil )
          
        # ... otherwise, if the inbound route status is NULL, FALSE or UNTRAVERSABLE...
        else
          # ... set the route status to the route status of the inbound route.
          update_route_hash( route, nil, @routes[inbound_routes[0]][:status], nil, nil, nil, nil, nil )
        end
      end
    end
  end
end
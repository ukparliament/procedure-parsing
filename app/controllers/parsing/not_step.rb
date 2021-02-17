module PARSING_NOT_STEP
  
  def parse_route_from_not_step( route, source_step, procedure, inbound_routes )
  
    # If the NOT step does not have one and only one inbound route ...
    if inbound_routes.size != 1
  
      # ... flag the step has an unexpected number of routes.
      logger.error "NOT step with ID #{source_step.id} has #{inbound_routes.size} inbound routes."
  
    # Otherwise, if the business step has one and only one inbound route ...
    else
  
      # If the inbound route has been parsed ....
      unless @routes[inbound_routes[0]][:parsed] == true
    
        # ... set the parsed attribute to true because this route will be parsed.
        update_route_hash( route, nil, nil, true, nil, nil, nil, nil )
        
        # ... if the inbound route has a status of 'UNTRAVERSABLE'
        if @routes[inbound_routes[0]][:status] == 'UNTRAVERSABLE'
        
          # ... set the route status to 'UNTRAVERSABLE'
  				update_route_hash( route, nil, 'UNTRAVERSABLE', nil, nil, nil, nil, nil )
      
        # ... otherwise if the inbound route has a status of 'NULL'
        elsif @routes[inbound_routes[0]][:status] == 'NULL'
        
          # ... set the route status to 'NULL'
  				update_route_hash( route, nil, 'NULL', nil, nil, nil, nil, nil )
      
        # ... otherwise if the inbound route has a status of 'TRUE'
        elsif @routes[inbound_routes[0]][:status] == 'TRUE'
        
          # ... set the route status to 'FALSE'
  				update_route_hash( route, nil, 'FALSE', nil, nil, nil, nil, nil )
      
        # ... otherwise if the inbound route has a status of 'FALSE'
        elsif @routes[inbound_routes[0]][:status] == 'FALSE'
        
          # ... set the route status to 'TRUE'
  				update_route_hash( route, nil, 'TRUE', nil, nil, nil, nil, nil )
        end
      end
    end
  end
end
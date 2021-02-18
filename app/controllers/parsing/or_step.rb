module PARSING_OR_STEP
  
  def parse_route_from_or_step( route, source_step, procedure, inbound_routes )
  
    # If the OR step does not have two and only two inbound routes ...
    if inbound_routes.size != 2
  
      # ... flag the step has an unexpected number of routes.
      logger.error "OR step with ID #{source_step.id} has #{inbound_routes.size} inbound routes."
  
    # Otherwise, if the OR step has exactly two inbound routes ...
    else
      
      # ... if both inbound routes have been parsed ....
      if @routes[inbound_routes[0]][:status] != 'UNPARSED' and @routes[inbound_routes[1]][:status] != 'UNPARSED'
        
        # ... update the parse log.
        @parse_log << 'Parsed'
    
        # ... set the parsed attribute to true because this route will be parsed.
        update_route_hash( route, nil, nil, true, nil, nil, nil, nil )
        
        # ... if either inbound route has a status of 'TRUE' ...
        if @routes[inbound_routes[0]][:status] == 'TRUE' or @routes[inbound_routes[1]][:parsed] == 'TRUE'
        
          # ... set the route status to 'TRUE'.
          update_route_hash( route, nil, 'TRUE', nil, nil, nil, nil, nil )
        
        # ... otherwise, if either inbound route has a status of 'UNTRAVERSABLE' ...
        elsif @routes[inbound_routes[0]][:status] == 'UNTRAVERSABLE' or @routes[inbound_routes[1]][:parsed] == 'UNTRAVERSABLE'
        
          # ... set the route status to 'UNTRAVERSABLE'.
          update_route_hash( route, nil, 'UNTRAVERSABLE', nil, nil, nil, nil, nil )
        
        # ... otherwise, if either inbound route has a status of 'FALSE' ...
        elsif @routes[inbound_routes[0]][:status] == 'FALSE' or @routes[inbound_routes[1]][:parsed] == 'FALSE'
        
          # ... set the route status to 'FALSE'.
          update_route_hash( route, nil, 'FALSE', nil, nil, nil, nil, nil )
        
        # ... otherwise, if both inbound routes have a status of 'NULL' ...
        elsif @routes[inbound_routes[0]][:status] == 'NULL' or @routes[inbound_routes[1]][:parsed] == 'NULL'
        
          # ... set the route status to 'NULL'.
          update_route_hash( route, nil, 'NULL', nil, nil, nil, nil, nil )
        end
      end
        
      # ... otherwise if one inbound route 1 has been parsed and inbound route 2 has not been parsed ....
      unless @routes[inbound_routes[0]][:status] != 'UNPARSED' and @routes[inbound_routes[1]][:status] == 'UNPARSED'
        
        # ... set the route status to the route status of inbound route 1
        update_route_hash( route, nil, @routes[inbound_routes[0]][:status], nil, nil, nil, nil, nil )
      end
      
      # ... otherwise if one inbound route 1 has not been parsed and inbound route 2 has been parsed ....
      unless @routes[inbound_routes[0]][:status] == 'UNPARSED' and @routes[inbound_routes[1]][:status] != 'UNPARSED'
        
        # ... set the route status to the route status of inbound route 2
        update_route_hash( route, nil, @routes[inbound_routes[1]][:status], nil, nil, nil, nil, nil )
      end
        
      # ...otherwise, if neither inbound route has been parsed ...
      # ... do nothing and parse on subsequent pass.
    end
  end
end
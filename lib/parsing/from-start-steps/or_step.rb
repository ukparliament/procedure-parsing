module PARSE_OR_STEP_FROM_START_STEPS
  
  # # Method to parse a route whose source step is an OR step.
  def parse_route_from_or_step( route, source_step, procedure, inbound_routes )
  
    # If the OR step does not have exactly two inbound routes ...
    if inbound_routes.size != 2
  
      # ... flag the step has an unexpected number of routes.
      logger.error "OR step with ID #{source_step.id} has #{inbound_routes.size} inbound routes."
  
    # Otherwise, if the OR step has exactly two inbound routes ...
    else
      
      # ... if both inbound routes to the source step have been parsed ....
      if @routes[inbound_routes[0]][:parsed] == true and @routes[inbound_routes[1]][:parsed] == true
        
        # ... we update the parse log to say this route has also been parsed.
        @parse_log << 'Parsed'
    
        # ... we update the route parsed attribute to true.
        update_route_hash( route, nil, nil, true, nil, nil, nil, nil, nil )
        
        # ... we refer to the [OR step truth table](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#truth-table-or) ...
        # ... and if either inbound route to the source step has a status of 'TRUE' ...
        if @routes[inbound_routes[0]][:status] == 'TRUE' or @routes[inbound_routes[1]][:parsed] == 'TRUE'
        
          # ... we set the status of this route to 'TRUE'.
          update_route_hash( route, nil, 'TRUE', nil, nil, nil, nil, nil, nil )
          
          puts "parsed as TRUE"
        
        # ... otherwise, if either inbound route to the source step has a status of 'UNTRAVERSABLE' ...
        elsif @routes[inbound_routes[0]][:status] == 'UNTRAVERSABLE' or @routes[inbound_routes[1]][:parsed] == 'UNTRAVERSABLE'
        
          # ... we set the status of this route to 'UNTRAVERSABLE' ...
          # ... tainting the roads off the bridge as closed if the bridge is closed.
          update_route_hash( route, nil, 'UNTRAVERSABLE', nil, nil, nil, nil, nil, nil )
          
        # ... otherwise, if either inbound route has a status of 'FALSE' ...
        elsif @routes[inbound_routes[0]][:status] == 'FALSE' or @routes[inbound_routes[1]][:parsed] == 'FALSE'
        
          # ... we set the status of this route to 'FALSE'.
          update_route_hash( route, nil, 'FALSE', nil, nil, nil, nil, nil, nil )
          
          puts "parsed as FALSE"
        
        # ... otherwise, if both inbound routes have a status of 'NULL' ...
        elsif @routes[inbound_routes[0]][:status] == 'NULL' or @routes[inbound_routes[1]][:parsed] == 'NULL'
        
          # ... set the status of this route to 'NULL'.
          update_route_hash( route, nil, 'NULL', nil, nil, nil, nil, nil, nil )
          
          puts "parsed as NULL"
        end
      
      # ... otherwise if the first inbound route has been parsed and the second inbound route has not been parsed ....
      elsif @routes[inbound_routes[0]][:parsed] == true and @routes[inbound_routes[1]][:parsed] == false
        
        # ... we treat the second route status as being NULL, remembering that a NULL value entering a logic step renders that gate ‘transparent’ ...
        # ... and we set the status of this route to the status of the first inbound route.
        update_route_hash( route, nil, @routes[inbound_routes[0]][:status], nil, nil, nil, nil, nil, nil )
      
      # ... otherwise if the first inbound route has not been parsed and the second inbound route has been parsed ....
      elsif @routes[inbound_routes[0]][:parsed] == false and @routes[inbound_routes[1]][:parsed] == true
        
        # ... we treat the first route status as being NULL, remembering that a NULL value entering a logic step renders that gate ‘transparent’ ...
        # ... and we set the status of this route to the status of the second inbound route.
        update_route_hash( route, nil, @routes[inbound_routes[1]][:status], nil, nil, nil, nil, nil, nil )
          
          puts "parsed as #{@routes[inbound_routes[1]][:status]}"
        
      # ...otherwise, if neither inbound route has been parsed ...
      # ... we do nothing and parse this route on a subsequent pass.
      end
    end
  end
end
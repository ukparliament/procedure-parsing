# # Module to parse a route whose source step is a NOT step.
module PARSE_NOT_STEP
  
  # ## Method to parse a route whose source step is a NOT step.
  def parse_route_from_not_step( route, source_step, procedure, inbound_routes )
  
    # If the NOT step does not have exactly one inbound route ...
    if inbound_routes.size != 1
  
      # ... flag the step has an unexpected number of routes.
      logger.error "NOT step with ID #{source_step.id} has #{inbound_routes.size} inbound routes."
  
    # Otherwise, if the NOT step has exactly one inbound route ...
    else
  
      # ... if the inbound route to the source step has been parsed ....
      if @routes[inbound_routes[0]][:parsed] == true
    
        # ... we update the route parsed attribute to true.
        update_route_hash( route, nil, nil, true, nil, nil, nil, nil, nil )
        
        # ... we refer to the [NOT step truth table](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#truth-table-not) ...
        
        # ... we check the status of the inbound route to the source step ...
        case @routes[inbound_routes[0]][:status]
        # ... and if the status of the inbound route to the source step is 'TRUE' ...
        when 'TRUE'
          
          # ... we set the status of this route to 'FALSE'.
          update_route_hash( route, nil, 'FALSE', nil, nil, nil, nil, nil, nil )
          
        # ... and if the status of the inbound route to the source step is 'FALSE' ...
        when 'FALSE'
          
          # ... we set the status of this route to 'TRUE'.
          update_route_hash( route, nil, 'TRUE', nil, nil, nil, nil, nil, nil )
          
        # ... and if the status of the inbound route is 'NULL' or 'UNTRAVERSABLE' ...
        else
          
          # ... we set the status of this route to the status of the inbound route.
          update_route_hash( route, nil, @routes[inbound_routes[0]][:status], nil, nil, nil, nil, nil, nil )
        end
        
      # ...otherwise, if the inbound route has not been parsed ...
      # ... we do nothing and parse on a subsequent pass.
      end
    end
  end
end
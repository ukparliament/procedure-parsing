# # Module to parse a route whose source step is a decision step.
module PARSE_DECISION_STEP
  
  # ## Method to parse a route whose source step is a decision step.
  def parse_route_from_decision_step( route, source_step, inbound_routes )
    
    # Design note: The [method used](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#validating-inputs-and-outputs-to-steps) for validating the number of input and output route for each step type.
    # If the decision step does not have exactly one inbound route ...
    if inbound_routes.size != 1
  
      # ... flag the step has an unexpected number of routes.
      logger.error "Decision step with ID #{source_step.id} has #{inbound_routes.size} inbound routes."
  
    # Otherwise, if the decision step has exactly one inbound route ...
    else
  
      # ... if the inbound route to the source step has been parsed ....
      if @routes[inbound_routes[0]][:parsed] == true
    
        # ... we update the route parsed attribute to true.
        update_route_hash( route, nil, nil, true, nil )
        
        # ... we refer to the [decision step truth table](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#truth-table-decision) ...
        
        # ... and if the status of the inbound route to the source step is 'TRUE' ...
        if @routes[inbound_routes[0]][:status] == 'TRUE'
        
          # ... we set the status of this route to 'ALLOWS'.
  				update_route_hash( route, nil, 'ALLOWS', nil, nil )
          
        # ... otherwise, if the status of the inbound route to the source step is NULL, FALSE or UNTRAVERSABLE ...
        else
          
          # ... we set the status of this route to the status of the inbound route.
          update_route_hash( route, nil, @routes[inbound_routes[0]][:status], nil, nil )
        end
        
      # ...otherwise, if the inbound route has not been parsed ...
      # ... we do nothing and parse on a subsequent pass.
      end
    end
  end
end
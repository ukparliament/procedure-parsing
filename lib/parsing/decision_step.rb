# # Module to parse a route whose source step is a decision step.
module PARSE_DECISION_STEP
  
  # ## Method to parse a route whose source step is a decision step.
  def parse_route_from_decision_step( route, source_step, inbound_routes )
    
    # Design note: The [method used](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#validating-inputs-and-outputs-to-steps) for validating the number of input and output routes for each step type.
    # If the decision step does not have one inbound route ...
    if inbound_routes.size != 1
  
      # ... log the step as has having an unexpected number of inbound routes.
      logger.error "Decision step with ID #{source_step.id} has #{inbound_routes.size} inbound routes."
  
    # Otherwise, if the decision step does have one inbound route ...
    else
  
      # ... if the inbound route to the source step has been parsed ....
      if @routes[inbound_routes[0].id][:parsed] == true
    
        # ... we update the route parsed attribute to true.
        update_route_hash( route, nil, nil, true, nil )
        
        # ... we refer to the [decision step truth table](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#truth-table-decision) ...
        
        # ... and if the status of the inbound route to the source step is 'TRUE' ...
        if @routes[inbound_routes[0].id][:status] == 'TRUE'
        
          # ... we set the status of this route to 'ALLOWS'.
  				update_route_hash( route, nil, 'ALLOWS', nil, nil )
          
        # ... otherwise, if the status of the inbound route to the source step is not ‘TRUE’ ...
        else
          
          # ... we set the status of this route to the status of the inbound route.
          update_route_hash( route, nil, @routes[inbound_routes[0].id][:status], nil, nil )
        end
        
      # Otherwise, the inbound route is not parsed and will be parsed on a later pass.
      end
    end
  end
end
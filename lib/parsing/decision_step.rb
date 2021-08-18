# # Module to parse a route whose source step is a decision step.
module PARSE_DECISION_STEP
  
  # ## Method to parse a route whose source step is a decision step.
  def parse_route_from_decision_step( route_id )
    
    # Design note: The [method used](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/with-step-types/#validating-inputs-and-outputs-to-steps) for validating the number of input and output routes for each step type.
    # If the decision step does not have one inbound route ...
    if step_inbound_routes( route_source_step_id( route_id ) ).size != 1
  
      # ... log the step as has having an unexpected number of inbound routes.
      logger.error "Decision step with name #{route_source_step_name( route_id )} has #{step_inbound_routes( route_source_step_id( route_id ) ).size} inbound routes."
  
    # Otherwise, the decision step does have one inbound route ...
    else
      
      # ... we get the ID of the first - and in this case only - inbound route.
      inbound_route_id = step_first_inbound_route( route_source_step_id( route_id ) )
  
      # If the inbound route to the source step has been parsed ....
      if route_parsed_attribute( inbound_route_id ) == true
    
        # ... we update the route parsed attribute to true.
        update_route_hash( route_id, nil, nil, true, nil, nil )
        
        # We refer to the [decision step truth table](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#truth-table-decision) ...
        
        # ... and if the status of the inbound route to the source step is 'TRUE' ...
        if route_status_attribute( inbound_route_id ) == 'TRUE'
        
          # ... we set the status of this route to 'ALLOWS' ...
  				update_route_hash( route_id, nil, 'ALLOWS', nil, nil, nil )
          
        # ... otherwise, the status of the inbound route to the source step not being ‘TRUE’ ...
        else
          
          # ... we set the status of this route to the status of the inbound route.
          update_route_hash( route_id, nil, route_status_attribute( inbound_route_id ), nil, nil, nil )
        end
        
      # Otherwise, the inbound route is not parsed and will be parsed on a later pass.
      end
    end
  end
end
# # Module to parse a route whose source step is a NOT step.
module PARSE_NOT_STEP
  
  # ## Method to parse a route whose source step is a NOT step.
  def parse_route_from_not_step( route_id )
    
    # Design note: The [method used](https://ukparliament.github.io/ontologies/procedure/maps/meta/design-notes/#validating-inputs-and-outputs-to-steps) for validating the number of input and output routes for each step type.
    # If the NOT step does not have one inbound route ...
    if step_inbound_routes( route_source_step_id( route_id ) ).size != 1
  
      # ... log the step as has having an unexpected number of inbound routes.
      logger.error "NOT step with name #{route_source_step_name( route_id )} has #{step_inbound_routes( route_source_step_id( route_id ) ).size} inbound routes."
  
    # Otherwise, the NOT step does have one inbound route ...
    else
      
      # ... we get the ID of the first - and in this case only - inbound route.
      inbound_route_id = step_first_inbound_route( route_source_step_id( route_id ) )
  
      # If the inbound route to the source step has been parsed ...
      if route_parsed_attribute( inbound_route_id ) == true
    
        # ... we update the route parsed attribute to true.
        update_route_hash( route_id, nil, nil, true, nil, nil )
        
        # We refer to the [NOT step truth table](https://ukparliament.github.io/ontologies/procedure/maps/meta/design-notes/#not-steps) ...
        
        # ... and we check the status of the inbound route to the source step.
        case route_status_attribute( inbound_route_id )
        
        # When the status of the inbound route to the source step is 'TRUE' ...
        when 'TRUE'
          
          # ... we set the status of this route to 'FALSE'.
          update_route_hash( route_id, nil, 'FALSE', nil, nil, nil )
          
        # When the status of the inbound route to the source step is 'FALSE' ...
        when 'FALSE'
          
          # ... we set the status of this route to 'TRUE'.
          update_route_hash( route_id, nil, 'TRUE', nil, nil, nil )
          
        # Otherwise, the status of the inbound route being neither ‘TRUE’ nor ‘FALSE’ ...
        else
          
          # ... we set the status of this route to the status of the inbound route.
          update_route_hash( route_id, nil, route_status_attribute( inbound_route_id ), nil, nil, nil )
        end
        
      # Otherwise, the inbound route is not parsed and will be parsed on a later pass.
      end
    end
  end
end
# # Module to parse a route whose source step is a PLUS step.
module PARSE_PLUS_STEP
  
  # ## Method to parse a route whose source step is a PLUS step.
  def parse_route_from_plus_step( route_id )
    
    # Design note: The [method used](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#validating-inputs-and-outputs-to-steps) for validating the number of input and output routes for each step type.
    # If the PLUS step does not have two inbound routes ...
    if step_inbound_routes( route_source_step_id( route_id ) ).size != 2
      
      # ... log the step as has having an unexpected number of inbound routes.
      logger.error "PLUS step with name #{route_source_step_name( route_id )} has #{step_inbound_routes( route_source_step_id( route_id ) ).size} inbound routes."
  
    # The appearance of inbound routes in first or second place has no meaning beyond the order they are delivered from the data store.
    # Otherwise, the PLUS step does have two inbound routes.
    else
      
      # We get the ID of the first inbound route ...
      first_inbound_route_id = step_first_inbound_route( route_source_step_id( route_id ) )
      
      # ... and we get the ID of the second inbound route.
      second_inbound_route_id = step_second_inbound_route( route_source_step_id( route_id ) )
      
      # ### If both inbound routes to the source step have been parsed ...
      if route_parsed_attribute( first_inbound_route_id ) == true and route_parsed_attribute( second_inbound_route_id ) == true
        
        # ... we update the route parsed attribute to true.
        update_route_hash( route_id, nil, nil, true, nil, nil )
        
        # Referring to the [design notes for artithmetic steps](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/with-step-types/#arithmetic-steps) ...
        
        # ... if either inbound route to the source step has a status of 'UNTRAVERSABLE' ...
        if route_is_untraversable?( first_inbound_route_id ) or route_is_untraversable?( second_inbound_route_id )
        
          # ... we set the status of this route to 'UNTRAVERSABLE' ...
          # ... tainting the roads off the bridge as closed if the bridge is closed.
          update_route_hash( route_id, nil, 'UNTRAVERSABLE', nil, nil, nil )
          
        # Otherwise, if neither inbound route to the source step has a status of 'UNTRAVERSABLE' ...
        else
          
          # We sum the actualisation counts of the two routes ...
          sum = route_actualisation_count( first_inbound_route_id ) + route_actualisation_count( second_inbound_route_id )
          
          # ... and set the actualisation count of this route to the value of the sum.
          update_route_hash( route_id, nil, nil, nil, sum, nil )
        end
        
      # ### Otherwise if the first inbound route has been parsed and the second inbound route has not been parsed ...
      elsif route_parsed_attribute( first_inbound_route_id ) == true and route_parsed_attribute( second_inbound_route_id ) == false
        
        # ... we set the actualisation count of this route to the actualisation count of the first inbound route.
        update_route_hash( route_id, nil, nil, nil, route_actualisation_count( first_inbound_route_id ), nil )
        
      # ### Otherwise if the first inbound route has not been parsed and the second inbound route has been parsed ...
      elsif route_parsed_attribute( first_inbound_route_id ) == false and route_parsed_attribute( second_inbound_route_id ) == true
        
        # ... we set the actualisation count of this route to the actualisation count of the second inbound route.
        update_route_hash( route_id, nil, nil, nil, route_actualisation_count( second_inbound_route_id ), nil )
        
      # ### Otherwise, neither inbound route has been parsed and this route will be parsed on a later pass.
      end
    end
  end
end
# # Module to parse a route whose source step is a business step.
module PARSE_BUSINESS_STEP
  
  # ## Method to parse a route whose source step is a business step.
  def parse_route_from_business_step( route_id )
  
    # Design note: The [method used](https://ukparliament.github.io/ontologies/procedure/maps/meta/design-notes/#validating-inputs-and-outputs-to-steps) for validating the number of input and output routes for each step type.
    # If the business step does not have one inbound route ...
    if step_inbound_routes( route_source_step_id( route_id ) ).size != 1
      
      # ... log the step as has having an unexpected number of inbound routes.
      logger.error "Business step with name #{route_source_step_name( route_id )} has #{step_inbound_routes( route_source_step_id( route_id ) ).size} inbound routes."
  
    # Otherwise, the business step does have one inbound route ...
    else
      
      # ... we get the ID of the inbound route.
      inbound_route_id = step_first_inbound_route( route_source_step_id( route_id ) )
      
      # We refer to the [design notes for assigning attributes to a route from a business step](https://ukparliament.github.io/ontologies/procedure/maps/meta/design-notes/#routes-from-business-steps).
      # If the inbound route to the source step has a status of 'UNTRAVERSABLE' ...
      if route_is_untraversable?( inbound_route_id )
          
        # ... then “the bridge is closed” and we set the “roads off the bridge” as closed ...
        # ... by setting the status of this route to be 'UNTRAVERSABLE' and the parsed attribute to true.
        update_route_hash( route_id, nil, 'UNTRAVERSABLE', true, nil, nil )
          
      # ... otherwise, the inbound route to the source step not having a status of 'UNTRAVERSABLE' ...
      else
        
        # ... if the source step has been actualised by a business item with a date in the past or a date of today ...
        if step_has_been_actualised_has_happened?( route_source_step_id( route_id ) )
          
          # ... we set the route status to 'TRUE', the actualisation count to the actualisations has happened count of the business step and the parsed attribute to true.
          update_route_hash( route_id, nil, 'TRUE', true, route_source_step_actualised_has_happened_count( route_id ), nil )
            
        # ... otherwise, the source step has not been actualised or has only been actualised by business items with dates in the future or by business items with no date ...
        else
            
          # ... and we set the route status to 'FALSE', the actualisation count to 0 and the parsed attribute to true.
          update_route_hash( route_id, nil, 'FALSE', true, 0, nil )
        end
      end
    end
  end
end
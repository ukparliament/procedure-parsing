# ## Module to parse a route whose source step is an AND step.
module PARSE_AND_STEP
  
  # ## Method to parse a route whose source step is an AND step.
  def parse_route_from_and_step( route_id )
  
    # Design note: The [method used](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#validating-inputs-and-outputs-to-steps) for validating the number of input and output routes for each step type.
    # If the AND step does not have two inbound routes ...
    if @routes_to_steps[@routes[route_id][:route].from_step_id].size != 2
      
      # ... log the step as has having an unexpected number of inbound routes.
      logger.error "AND step with name #{@routes[route_id][:route].source_step_name} has #{@routes_to_steps[@routes[route_id][:route].from_step_id].size} inbound routes."
  
    # Otherwise, if the AND step does have two inbound routes ...
    # The appearance of inbound routes in first or second place has no meaning beyond the order they are delivered from the data store.
    else
      
      # ... we get the ID of the first inbound route.
      first_inbound_route_id = @routes_to_steps[@routes[route_id][:route].from_step_id][0]
      
      # ... we get the ID of the second inbound route.
      second_inbound_route_id = @routes_to_steps[@routes[route_id][:route].from_step_id][1]
      
      # ### ... if both inbound routes to the source step have been parsed ...
      if @routes[first_inbound_route_id][:parsed] == true and @routes[second_inbound_route_id][:parsed] == true
    
        # ... we update the route parsed attribute to true.
        update_route_hash( route_id, nil, nil, true, nil )
        
        # ... we refer to the [AND step truth table](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#truth-table-and) ...
        
        # ... if either inbound route to the source step has a status of 'UNTRAVERSABLE' ...
        if @routes[first_inbound_route_id][:status] == 'UNTRAVERSABLE' or @routes[second_inbound_route_id][:status] == 'UNTRAVERSABLE'
        
          # ... we set the status of this route to 'UNTRAVERSABLE' ...
          # ... tainting the roads off the bridge as closed if the bridge is closed ...
          update_route_hash( route_id, nil, 'UNTRAVERSABLE', nil, nil )
        
        # ... otherwise, if either inbound input route to the source step has a status of 'FALSE' ...
        elsif @routes[first_inbound_route_id][:status] == 'FALSE' or @routes[second_inbound_route_id][:status] == 'FALSE'
        
          # ... we set the status of this route to 'FALSE'.
          update_route_hash( route_id, nil, 'FALSE', nil, nil )
          
        # ... otherwise, if the first inbound route has a status of 'TRUE' and the second inbound route has a status of 'NULL' ...
        elsif @routes[first_inbound_route_id][:status] == 'TRUE' and @routes[second_inbound_route_id][:status] == 'NULL'
          
          # ... we set the status of this route to 'TRUE'.
          update_route_hash( route_id, nil, 'TRUE', nil, nil )
          
        # ... otherwise, if the first inbound route has a status of 'NULL' and the second inbound route has a status of 'TRUE' ...
        elsif @routes[first_inbound_route_id][:status] == 'NULL' and @routes[second_inbound_route_id][:status] == 'TRUE'
          
          # ... we set the status of this route to 'TRUE'.
          update_route_hash( route_id, nil, 'TRUE', nil, nil )
          
        # ... otherwise, if both inbound routes have a status of 'TRUE' ...
        elsif @routes[first_inbound_route_id][:status] == 'TRUE' and @routes[second_inbound_route_id][:status] == 'TRUE'
          
          # ... we set the status of this route to 'TRUE'.
          update_route_hash( route_id, nil, 'TRUE', nil, nil )
          
        # ... otherwise, if both inbound routes have a status of 'NULL' ...
        elsif @routes[first_inbound_route_id][:status] == 'NULL' and @routes[second_inbound_route_id][:status] == 'NULL'
          
          # ... we set the status of this route to 'NULL'.
          update_route_hash( route_id, nil, 'NULL', nil, nil )
        end
      
      # ### Otherwise if the first inbound route has been parsed and the second inbound route has not been parsed ...
      elsif @routes[first_inbound_route_id][:parsed] == true and @routes[second_inbound_route_id][:parsed] == false
        
        # ... we treat the second route status as being NULL, remembering that a NULL value entering a logic gate step renders that gate as 'transparent' ...
        # ... and we set the status of this route to the status of the first inbound route.
        update_route_hash( route_id, nil, @routes[first_inbound_route_id][:status], nil, nil )
      
      # ### Otherwise if the first inbound route has not been parsed and the second inbound route has been parsed ...
      elsif @routes[first_inbound_route_id][:parsed] == false and @routes[second_inbound_route_id][:parsed] == true
        
        # ... we treat the first route status as being NULL, remembering that a NULL value entering a logic step renders that gate as 'transparent' ...
        # ... and we set the status of this route to the status of the second inbound route.
        update_route_hash( route_id, nil, @routes[second_inbound_route_id][:status], nil, nil )
        
      # ### Otherwise, neither inbound route has been parsed and this route will be parsed on a later pass.
      end
    end
  end
end
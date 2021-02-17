module PARSING_BUSINESS_STEP
  
  def parse_route_from_business_step( route, source_step, procedure, inbound_routes )
  
    # If the business step does not have one and only one inbound route ...
    if inbound_routes.size != 1
  
      # ... flag the step has an unexpected number of routes
      logger.error "Business step with ID #{source_step.id} has #{inbound_routes.size} inbound routes."
  
    # Otherwise, if the business step has one and only one inbound route ...
    else
  
      # If the inbound route has been parsed ....
      unless @routes[inbound_routes[0]][:parsed] == true
    
        # ... set the parsed attribute to 'TRUE' because this route will be parsed.
        update_route_hash( route, nil, nil, 'TRUE', nil, nil, nil, nil )
    
        # ... if the inbound route has a status of 'UNTRAVERSABLE'
        if @routes[inbound_routes[0]][:status] == 'UNTRAVERSABLE'
      
          # ... taint the roads off the bridge as closed if the bridge is closed.
          # ... setting the status of this route to also be 'UNTRAVERSABLE'.
  				update_route_hash( route, nil, 'UNTRAVERSABLE', nil, nil, nil, nil, nil )
      
        # ... otherwise if the inbound routes does not have a status of 'UNTRAVERSABLE'
        else
      
          # ... if the source step has been actualised by a business item with a date in the past or a date of today
          if source_step.actualised_has_happened_in_work_package?( @work_package )
        
            # ... set the route status to 'TRUE'
            update_route_hash( route, nil, 'TRUE', nil, nil, nil, nil, nil )
        
          # ... otherwise, if the source step has not been actualised or has only been actualised by business items with dates in the past ....
          else
        
            # ... set the route status to 'NULL'
            update_route_hash( route, nil, 'NULL', nil, nil, nil, nil, nil )
          end 
        end
      end
    end
  end
end
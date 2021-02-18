module PARSE_BUSINESS_STEP
  
  # # Method to parse a route whose source step is a business step.
  def parse_route_from_business_step( route, source_step, procedure, inbound_routes )
  
    # If the business step does not have one and only one inbound route ...
    if inbound_routes.size != 1
  
      # ... flag the step has having an unexpected number of routes.
      logger.error "Business step with ID #{source_step.id} has #{inbound_routes.size} inbound routes."
  
    # Otherwise, if the business step has one and only one inbound route ...
    else
      
      # ## We only parse a business step if it's inbound route has already been parsed.
      # This is a problem for start steps which are self precluding.
      # They point to a NOT step which points back to the start step.
      # Relying on the inbound route being parsed woukd rely on the outbound route being parsed and parsing could never start.
      # Therefore, for start steps we ignore the parsed attribute of the inbound route.
      # ... if the source step for this route is in the array of start steps ...
      if @start_steps.include?( source_step )
        
        # ... we update the parse log to say this route has been parsed.
        @parse_log << 'Parsed'
        
        # ... and if the source step has been actualised by a business item with a date in the past or a date of today ...
        if source_step.actualised_has_happened_in_work_package?( @work_package )
          
          # ... we set the route status to 'TRUE' and the route parsed attribute to true.
          update_route_hash( route, nil, 'TRUE', true, nil, nil, nil, nil )
          
        # ... otherwise, if the source step has not been actualised or has only been actualised by business items with dates in the past ....
        else
          
          # ... we set the route status to 'NULL' and the route parsed attribute to true.
          update_route_hash( route, nil, 'NULL', true, nil, nil, nil, nil )
        end
        
      # ... otherwise, if the source step for this route is not in the array of start steps...
      else
        
        # ...we treat the route as any other route with a source step of type business step ...
        # ... if the inbound route to the source step of the route has been parsed ....
        if @routes[inbound_routes[0]][:parsed] == true
        
          # ... we update the parse log to say this route has also been parsed.
          @parse_log << 'Parsed'
          
          # ... we updated the route parsed attribute to true.
          update_route_hash( route, nil, nil, true, nil, nil, nil, nil )
          
          # If the inbound route to the source step has a status of 'UNTRAVERSABLE' ...
          if @routes[inbound_routes[0]][:status] == 'UNTRAVERSABLE'
            
            # ... we taint the roads off the bridge as closed if the bridge is closed ...
            # ... by setting the status of this route to also be 'UNTRAVERSABLE'.
    			  update_route_hash( route, nil, 'UNTRAVERSABLE', nil, nil, nil, nil, nil )
            
          # ... otherwise, if the inbound route to the source step does not have a status of 'UNTRAVERSABLE' ...
          else
            
            # ... if the source step has been actualised by a business item with a date in the past or a date of today ...
            if source_step.actualised_has_happened_in_work_package?( @work_package )
              
              # ... set the route status to 'TRUE'.
              update_route_hash( route, nil, 'TRUE', nil, nil, nil, nil, nil )
              
            # ... otherwise, if the source step has not been actualised or has only been actualised by business items with dates in the past ....
            else
              
              # ... set the route status to 'NULL'.
              update_route_hash( route, nil, 'NULL', nil, nil, nil, nil, nil )
            end 
          end
          
        # ... otherwise, we do nothing and parse this route on a subsequent pass.
        end
      end
    end
  end
end
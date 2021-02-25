module PARSE_EQUAL_STEP_FROM_BUSINESS_STEPS
  
  # # Method to parse a route whose source step is a equals step.
  def parse_route_from_equal_step( route, source_step, procedure, inbound_routes )
  
    # If the equal step does not have exactly two inbound routes ...
    if inbound_routes.size != 2
  
      # ... flag the step has an unexpected number of routes.
      logger.error "Equal step with ID #{source_step.id} has #{inbound_routes.size} inbound routes."
  
    # Otherwise, if the equal step has exactly two inbound routes ...
    else
  
      # ... if both inbound routes to the source step have been parsed ....
      if @routes[inbound_routes[0]][:parsed] == true and @routes[inbound_routes[1]][:parsed] == true
        
        # ... we update the parse log to say this route has also been parsed.
        @parse_log << 'Parsed'
    
        # ... we update the route parsed attribute to true.
        update_route_hash( route, nil, nil, true, nil, nil, nil, nil )
        
        # ... if both inbound routes have a status of 'TRUE' ...
        if @routes[inbound_routes[0]][:status] == 'TRUE' and @routes[inbound_routes[1]][:status] == 'TRUE'
          
          # ... if the number of actualisations having happened of the source step of the first inbound route equals the number of actualisations having happened of the source step of the second inbound route ...
          if inbound_routes[0].source_step.actualised_has_happened_in_work_package?( work_package ).size == inbound_routes[0].source_step.actualised_has_happened_in_work_package?( work_package ).size
            
            # ... the number of withdrawals equals the number of tablings so no motions are in play ...
            # ... and we set the status of this route to 'FALSE'.
            update_route_hash( route, nil, 'FALSE', nil, nil, nil, nil, nil )
          
          # ... otherwise, if the number of actualisations having happened of the source step of the first inbound route does not equal the number of actualisations having happened of the source step of the second inbound route ...
          else
            
            # ... the number of withdrawals does not equal the number of tablings ...
            # ... we assume our librarians have not made a mistake and actualised withdrawals without tablings ...
            # ... and that there are still tablings with no withdrawals ...
            # ... and we set the status of this route to 'TRUE'.
            update_route_hash( route, nil, 'TRUE', nil, nil, nil, nil, nil )
              
          end
        
        end
        
      # ...otherwise, if the inbound route has not been parsed ...
      # ... do nothing and parse on subsequent pass.
      end
    end
  end
end
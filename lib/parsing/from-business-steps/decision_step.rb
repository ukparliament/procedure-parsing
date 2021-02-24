module PARSE_DECISION_STEP_FROM_BUSINESS_STEPS
  
  # # Method to parse a route whose source step is a decision step.
  def parse_route_from_decision_step( route, source_step, procedure, inbound_routes )
    
    # If the decision step does not have exactly one inbound route ...
    if inbound_routes.size != 1
  
      # ... flag the step has an unexpected number of routes.
      logger.error "Decision step with ID #{source_step.id} has #{inbound_routes.size} inbound routes."
  
    # Otherwise, if the NOT step has exactly one inbound route ...
    else
  
      # ... if the inbound route to the source step has been parsed ....
      if @routes[inbound_routes[0]][:parsed] == true
        
        # ... we update the parse log to say this route has also been parsed.
        @parse_log << 'Parsed'
    
        # ... we update the route parsed attribute to true.
        update_route_hash( route, nil, nil, true, nil, nil, nil, nil )
        
        # ... we refer to the [decision step truth table](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#truth-table-decision) ...
        
        # ... and if the status of the inbound route to the source step is 'TRUE' ...
        if @routes[inbound_routes[0]][:status] == 'TRUE'
        
          # ... we set the status of this route to 'ALLOWS'.
  				update_route_hash( route, nil, 'ALLOWS', nil, nil, nil, nil, nil )
          
        # ... otherwise, if the status of the inbound route to the source step is NULL, FALSE or UNTRAVERSABLE ...
        else
          
          # ... we set the status of this route to the status of the inbound route.
          update_route_hash( route, nil, @routes[inbound_routes[0]][:status], nil, nil, nil, nil, nil )
        end
        
      # ...otherwise, if the inbound route has not been parsed ...
      # ... do nothing and parse on subsequent pass.
      end
    end
  end
end
module PARSE_ASSIGN_POTENTIAL_BUSINESS_STEP_STATE
  
  def assign_potential_business_step_state( route )
    # ## ... we assign the potential state of any target business step.
    # If the route we're attempting to parse has been fully parsed ...
    if @routes[route][:parsed] == true
      
      # ... we write to the parse logger, reporting the route's parsed status.
      @parse_log << "Successfully parsed as <strong>#{@routes[route][:status]}</strong>."
      
      
      # Modularise this?
    
      # ... if the target step of the route we've just parsed is a business step ...
      if route.target_step.step_type_name == 'Business step'
    
        # ... if the status of the route we've just parsed is 'TRUE' ...
        if @routes[route][:status] == 'TRUE'
      
          # ... we add the target step to the array of caused steps, unless it is already in that array.
          @caused_steps << route.target_step
      
        # ... if the status of the route we've just parsed is 'ALLOWS' ...
        elsif @routes[route][:status] == 'ALLOWS'
      
          # ... we add the target step to the array of allowed steps, unless it is already in that array.
          @allowed_steps << route.target_step
      
        # ... if the status of the route we've just parsed is 'FALSE' or 'NULL' ...
        elsif @routes[route][:status] == 'NULL' or  @routes[route][:status] == 'FALSE'
      
          # ... we add the target step to the array of disallowed as yet steps, unless it is already in that array.
          @disallowed_yet_steps << route.target_step
      
        # ... if the status of the route we've just parsed is 'UNTRAVERSABLE' ...
        elsif @routes[route][:status] == 'UNTRAVERSABLE'
      
          # ... we add the target step to the array of disallowed now steps, unless it is already in that array.
          @disallowed_now_steps << route.target_step
        end
      end
    end
  end
end
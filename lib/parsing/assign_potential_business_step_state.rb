# # Module to assign potential state to a business step.
module PARSE_ASSIGN_POTENTIAL_BUSINESS_STEP_STATE
  
  # ## Method to assign a [potential state](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#potential-states-of-a-business-step) to a business step, being the target of a parsed route.
  def assign_potential_business_step_state( route )
    
    # If the route we're attempting to parse has been fully parsed ...
    if @routes[route][:parsed] == true
      
      # ... we write to the parse logger, reporting the route's parsed status.
      @parse_log << "Successfully parsed as <strong>#{@routes[route][:status]}</strong>."
    
      # ... if the target step of the route we've parsed is a business step ...
      if route.target_step.step_type_name == 'Business step'
    
        # ... if the status of the route we've parsed is 'TRUE' ...
        if @routes[route][:status] == 'TRUE'
      
          # ... we add the target step to the array of caused steps, unless it is already in that array.
          @caused_steps << route.target_step unless @caused_steps.include?( route.target_step )
      
        # ... if the status of the route we've parsed is 'ALLOWS' ...
        elsif @routes[route][:status] == 'ALLOWS'
      
          # ... we add the target step to the array of allowed steps, unless it is already in that array.
          @allowed_steps << route.target_step unless @allowed_steps.include?( route.target_step )
      
        # ... if the status of the route we've parsed is 'FALSE' or 'NULL' ...
        elsif @routes[route][:status] == 'NULL' or  @routes[route][:status] == 'FALSE'
      
          # ... we add the target step to the array of disallowed as yet steps, unless it is already in that array.
          @disallowed_yet_steps << route.target_step unless @disallowed_yet_steps.include?( route.target_step )
      
        # ... if the status of the route we've parsed is 'UNTRAVERSABLE' ...
        elsif @routes[route][:status] == 'UNTRAVERSABLE'
      
          # ... we add the target step to the array of disallowed now steps, unless it is already in that array.
          @disallowed_now_steps << route.target_step unless @disallowed_now_steps.include?( route.target_step )
        end
      end
    end
  end
end
# # Module to initialise a hash of steps keyed off the step ID together with a hash of IDs of outbound routes from a step and a hash of IDs of inbound routes to a step, also keyed off the step ID.
module PARSE_STEP_HASH
  
  # ## Method to initialise a hash of steps keyed off the step ID together with a hash of IDs of outbound routes from a step and a hash of IDs of inbound routes to a step, also keyed off the step ID.
  def initialise_step_hashes( procedure )
    
    # We create three hashes: a hash to store all steps objects in a procedure, keyed off the step ID ...
    @steps = {}
    
    # ... a hash of IDs of outbound routes from each individual step, keyed off the step ID
    @routes_from_steps = {}
    
    # ... and a hash of IDs of inbound routes to each individual step, keyed off the step ID.
    @routes_to_steps = {}
    
    
    
    steps = procedure.steps_with_actualisations_in_work_package( @work_package )
    steps.each do |step|
      from_route_array = []
      to_route_array = []
    	@routes.each do |route|
        from_route_array << route[1][:route].id if route[1][:route].from_step_id == step.id
    		to_route_array << route[1][:route].id if route[1][:route].to_step_id == step.id
    	end
      @routes_from_steps[step.id] = from_route_array
      @routes_to_steps[step.id] = to_route_array
      @steps[step.id] = step
    end
  end
end
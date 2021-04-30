# # Module to initialise a hash of steps keyed off the step ID together with a hash of outbound routes from a step and inbound routes to a step, also keyed off the step ID.
module PARSE_STEP_HASH
  
  # ## Method to initialise initialise a hash of steps keyed off the step ID together wit hash of outbound routes from a step and inbound routes to a step, also keyed off the step ID.
  def initialise_step_hashes( procedure )
    @steps = {}
    @routes_from_steps = {}
    @routes_to_steps = {}
    steps = procedure.steps
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
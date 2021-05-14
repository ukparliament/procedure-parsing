# Module to initialise a hash of steps keyed off the step ID together with a hash of IDs of outbound routes from a step and a hash of IDs of inbound routes to a step, also keyed off the step ID.

module PARSE_STEP_HASH
## Method to initialise a hash of steps keyed off the step ID together with a hash of IDs of outbound routes from a step and a hash of IDs of inbound routes to a step, also keyed off the step ID.

  def initialise_step_hashes( procedure )
We create three hashes: a hash to store all steps objects in a procedure, keyed off the step ID ...

    @steps = {}
... a hash of IDs of outbound routes from each individual step, keyed off the step ID ...

    @routes_from_steps = {}
... and a hash of IDs of inbound routes to each individual step, keyed off the step ID.

    @routes_to_steps = {}
We get all steps attached to routes in the procedure.

We include a count of actualisations of business items in the work package having happened in the past or today.

    steps = procedure.steps_with_actualisations_in_work_package( @work_package )
For each step in the procedure ...

    steps.each do |step|
... we create an array to store the IDs of routes outbound from this step

      from_route_array = []
... and an array to store the IDs of routes inbound to this step.

      to_route_array = []
For each route in the procedure ...

    	@routes.each do |route|
... we add the ID of the route to the array of outbound IDs, if the route is outbound from this step ...

        from_route_array << route[0] if route[1][:route].from_step_id == step.id
... we add the ID of the route to the array of inbound IDs, if the route is inbound to this step ...

    		to_route_array << route[0] if route[1][:route].to_step_id == step.id
    	end
... we add the array of outbound route IDs to the hash of outbound routes, keyed off the step ID ...

      @routes_from_steps[step.id] = from_route_array
... we add the array of inbound route IDs to the hash of inbound routes, keyed off the step ID ...

      @routes_to_steps[step.id] = to_route_array
... and we add the step object to the hash of steps, keyed off the step ID.

      @steps[step.id] = step
    end
  end
## A set of methods to get attributes of the steps hash.

We call all methods with the ID of the step.

### Method to get the step object from the steps hash.

  def step_object( step_id )
    @steps[step_id]
  end
### Method to get the name of a step from the steps hash.

  def step_name( step_id )
    step_object( step_id )[:name]
  end
### Method to check if a step has been actualised with a business item having a date in the past or of today.

  def step_has_been_actualised_has_happened?( step_id )
We assume the step has not been actualised with a business item having a date in the past or of today.

    actualised_has_happened = false
We set the actualised_has_happened boolean to true if the step has been actualised in this work package, by at least one business item having a date in the past or of today.

    actualised_has_happened = true if step_object( step_id ).is_actualised_has_happened
We return the boolean.

    actualised_has_happened
  end
### Method to check if a step has been actualised with a business item, regardless of the date of that business item.

  def step_has_been_actualised?( step )
We assume the step has not been actualised with a business item.

    actualised = false
We set the actualised boolean to true if the step has been actualised in this work package, by at least one business item.

    actualised = true if step.is_actualised?
We return the boolean.

    actualised
  end
### Method to get an array of IDs of inbound routes to a step.

  def step_inbound_routes( step_id )
    @routes_to_steps[step_id]
  end
### Method to get the ID of the first inbound route to a step.

The appearance of inbound routes in first or second place has no meaning beyond the order they are delivered from the data store.

  def step_first_inbound_route( step_id )
    step_inbound_routes( step_id )[0]
  end
### Method to get the ID of the second inbound route to a step.

The appearance of inbound routes in first or second place has no meaning beyond the order they are delivered from the data store.

  def step_second_inbound_route( step_id )
    step_inbound_routes( step_id )[1]
  end
### Method to get outbound routes from a step.

  def step_outbound_routes( step_id )
    @routes_from_steps[step_id]
  end
end
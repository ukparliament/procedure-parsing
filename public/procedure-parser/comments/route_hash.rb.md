# Module to initialise, create and update a hash of a hash of route attributes keyed off the ID of a route.

module PARSE_ROUTE_HASH
## Method to initialise a hash of a hash of route attributes keyed off the ID of a route.

We use this to store values that are generated from parsing and are not on the route model.

  def initialise_route_hash( work_package )
We get all routes which appear in the procedure the work package is subject to, together with the name and type of the source step of each route and the name and type of the target step of each route.

    routes = work_package.parliamentary_procedure.routes_with_steps
We record the number of routes in the procedure as an instance variable, so we can use it to report progress.

    @route_count = routes.size
If the procedure has no routes ...

    if routes.empty?
... we write to the log, explaining that the work package cannot be parsed.

      @parse_log << "Work package #{work_package.id} is subject to the #{work_package.parliamentary_procedure.name} procedure. This procedure has no routes and therefore the work package cannot be parsed."
Otherwise, if the procedure does have routes ...

    else
... we create a hash for the routes and their attributes.

This is created as an instance variable because we want to write to it as we parse and report on it later.

      @routes = {}
... we loop through the routes and ...

      routes.each do |route|
... for each route create a hash of values we want to store for that route.

        route_hash = create_and_add_route_hash(
          route, # We pass in the route which we'll use as the key of the hash.
          'NULL', # We pass in the current attribute to capture if the route is currently active. This is 'NULL' until the route is parsed.
          'UNPARSED', # We pass in the status attribute of the route. This is 'UNPARSED' until the route is parsed.
          false, # We pass in the parsed attribute of the route. This is false until the route is successfully parsed. A route may have many parse passes before being successfully parsed.
          0, # We pass in the actualised has happened count of the route. This is 0 until we parse either ...
... a route whose source is a business step, then we set this to the count of business items, with dates in the past or of today, actualising that step ...

... or a route whose source is a SUM step or an INCREMENT step, then we set this to the value output by the step.

          0 # We pass in the parse pass count attribute of this route. This is 0 until parsed.
        )
      end
    end
  end
## Method to create a hash of attributes for a route and to add the attributes hash to the containing routes hash.

  def create_and_add_route_hash( route, current, status, parsed, actualisation_count, parse_pass_count )
We create a hash of route attributes.

    route_hash = {
      :current => current,
      :status => status,
      :parsed => parsed,
      :actualisation_count => actualisation_count,
      :parse_pass_count => parse_pass_count,
      :route => route
    }
We add the hash to the routes hash, keyed off the ID of the route.

    @routes[route.id] = route_hash
  end
## Method to update the hash of attributes for a route within the containing route hash.

  def update_route_hash( route_id, current, status, parsed, actualisation_count, parse_pass_count )
We check if this method has been passed a value for an attribute.

Where the method has been passed nil as an attribute value, we use the attribute value as it exists in the hash.

    current = current || @routes[route_id][:current]
    status = status || @routes[route_id][:status]
    parsed = parsed || @routes[route_id][:parsed]
    actualisation_count = actualisation_count || @routes[route_id][:actualisation_count]
    parse_pass_count = parse_pass_count || @routes[route_id][:parse_pass_count]
We create a hash of attributes for the route with any revised values.

    route_hash = {
      :current => current,
      :status => status,
      :parsed => parsed,
      :actualisation_count => actualisation_count,
      :parse_pass_count => parse_pass_count,
      :route => @routes[route_id][:route]
    }
We push this back into the hash of routes, keyed off the ID of the route.

    @routes[route_id] = route_hash
  end
## A set of methods to get attributes of a route.

We call all methods with the ID of the route.

### Method to get the hash of route attributes from the routes hash.

  def route_hash( route_id )
    @routes[route_id]
  end
### Method to get the current attribute of the route hash.

  def route_current_attribute( route_id )
    route_hash( route_id )[:current]
  end
### Method to get the status attribute of the route hash.

  def route_status_attribute( route_id )
    route_hash( route_id )[:status]
  end
### Method to check if the untraversable attribute of the route is set to untraversable.

  def route_is_untraversable?( route_id )
We assume the route is traversable.

    untraversable = false
We set the value of untraversable to true if the routes hash has a status of ‘UNTRAVERSABLE’ for the route with this ID.

    untraversable = true if route_status_attribute( route_id ) == 'UNTRAVERSABLE'
We return the boolean.

    untraversable
  end
### Method to get the parsed attribute of the route hash.

  def route_parsed_attribute( route_id )
    route_hash( route_id )[:parsed]
  end
### Method to get the parse pass count attribute of the route hash.

  def route_parse_pass_count_attribute( route_id )
    route_hash( route_id )[:parse_pass_count]
  end
### Method to get the route object from the routes hash.

  def route_object( route_id )
    route_hash( route_id )[:route]
  end
### Method to check if a route is current.

  def route_is_current?( route_id )
A route may have start and end dates.

We get the start and end dates from the route object.

    start_date = route_object( route_id ).start_date
    end_date = route_object( route_id ).end_date
If the route has a start date and the start date is in the future, being after today ...

    if start_date and start_date > Date.today
.. we set current to false because the road is not yet open.

      current = false
Otherwise, if the route has an end date and the end date is in the past, being earlier than today ...

    elsif end_date and end_date < Date.today
... we set current to false because the road closed in the past.

      current = false
Otherwise, if the route has no start date or a start date in the past or no end date or an end date in the future ...

    else
... we set current to true because the road is open.

      current = true
    end
We return the value we've set for the route's currency.

    current
  end
### Method to get the ID of the source step of a route.

  def route_source_step_id( route_id )
We get the from_step_id of the route in the routes hash with this ID.

    route_object( route_id ).from_step_id
  end
### Method to get the name of the source step of a route.

  def route_source_step_name( route_id )
We get the name of the source step of the route in the routes hash with this ID.

    route_object( route_id ).source_step_name
  end
### Method to get the name of the type of the source step of a route.

  def route_source_step_type( route_id )
We get the name of the source step of the route in the routes hash with this ID.

    route_object( route_id ).source_step_type
  end
### Method to get the source step object of a route.

  def route_source_step( route_id )
We get the step object with the ID of the source step of the route.

    @steps[route_source_step_id( route_id )]
  end
### Method to get the ID of the target step of a route.

  def route_target_step_id( route_id )
We get the to_step_id of the route in the routes hash with this ID.

    route_object( route_id ).to_step_id
  end
### Method to get the name of the target step of a route.

  def route_target_step_name( route_id )
We get the name of the target step of the route in the routes hash with this ID.

    route_object( route_id ).target_step_name
  end
### Method to get the name of the type of the target step of a route.

  def route_target_step_type( route_id )
We get the name of the target step of the route in the routes hash with this ID.

    route_object( route_id ).target_step_type
  end
### Method to get the target step object of a route.

  def route_target_step( route_id )
We get the step object with the ID of the target step of the route.

    @steps[route_target_step_id( route_id )]
  end
### Method to check if the target step of a route is actualised by a business item, regardless of the date of that business item.

  def route_target_step_is_actualised?( route_id )
We check if the target step of the route has been actualised.

    step_has_been_actualised?( route_target_step( route_id ) )
  end
### Method to get the actualised as happened_count from the source step of a route.

  def route_source_step_actualised_has_happened_count( route_id )
We get the actualised as happened count from the source step.

    step_actualised_as_happened_count( route_source_step_id( route_id ) )
  end
### Method to get the actualisation count of a route.

  def route_actualisation_count( route_id )
We get the actualisation count of the route in the routes hash with this ID.

    route_hash( route_id )[:actualisation_count]
  end
end
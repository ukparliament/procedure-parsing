module PARSE_ROUTE_HASH  # ## Method to initialise a hash of a hash of route attributes keyed off the route.
  # We use this to store values that are generated from parsing and are not on the model.
  def initialise_route_hash( work_package )
  
    # We get all the routes in the procedure the work package is subject to.
    # We also get step name and the step type name for both the source and the target step of each route.
    routes = work_package.parliamentary_procedure.routes_with_steps
      
    # We record how many routes the procedure has.
    # Create as an instance variable so we can use to report progress.
    @route_count = routes.size
  
    # If the procedure has no routes ...
    if routes.empty?
    
      # ... we write to the log, explaining that the work package cannot be parsed.
      @parse_log << "Work package #{work_package.id} is subject to the subject to the #{work_package.parliamentary_procedure.name} procedure. This procedure has no routes and therefore the work package cannot be parsed."
    
    # Otherwise, if the procedure has routes ...
    else
  
      #  ... we create a hash to hold the routes and their attributes.
      #  ...create as an instance variable because we want to write to it as we parse and report on it later.
      @routes = {}
  
      # ... loop through the routes and ...
      routes.each do |route|
    
        # ... create a hash of values we want to store for the route
        route_hash = create_route_hash(
          route, # We pass in the route which we'll use as the key of the hash.
          'NULL', # We pass in the current attribute to capture if the route is currently active. This is 'NULL' until the route is parsed.
          'UNPARSED', # We pass in the status attribute of the route. This is 'UNPARSED' until the route is parsed.
          false, # We pass in the parsed attribute of the route. This is false until the route is fully parsed.
          0, # We pass in the parse pass count attribute of this route. This is 0 until parsed.
          route.source_step_name, # We pass in the name of the source step.
          route.source_step_type, # We pass in the name of the type of the source step.
          route.target_step_name, # We pass in the name of the target step.
          route.target_step_type # We pass in the name of the type of the target step.
        )
      end
    end
  end
  
  

  # ## Method to create a hash of attributes for a given route and add it to the containing route hash.
  def create_route_hash( route, current, status, parsed, parse_pass_count, source_step_name, source_step_type, target_step_name, target_step_type )
  
    # We create a hash of route attributes.
    route_hash = {
      :current => current,
      :status => status,
      :parsed => parsed,
      :parse_pass_count => parse_pass_count,
      :source_step_name => source_step_name,
      :source_step_type => source_step_type,
      :target_step_name => target_step_name,
      :target_step_type => target_step_type
    }
  
    # We add the hash to the routes hash, keyed off the route.
    @routes[route] = route_hash
  end

  # ## Method to update a hash of attributes for a given route and replace it in the containing route hash.
  def update_route_hash( route, current, status, parsed, parse_pass_count, source_step_name, source_step_type, target_step_name, target_step_type )
    
    # We check if this method has been passed a value for an attribute.
    # Where the method has been passed nil as an attribute value, we use the attribute value as it exists in the hash.
    current = current || @routes[route][:current]
    status = status || @routes[route][:status]
    parsed = parsed || @routes[route][:parsed]
    parse_pass_count = parse_pass_count || @routes[route][:parse_pass_count]
    source_step_name = source_step_name || @routes[route][:source_step_name]
    source_step_type = source_step_type || @routes[route][:source_step_type]
    target_step_name = target_step_name || @routes[route][:target_step_name]
    target_step_type = target_step_type || @routes[route][:target_step_type]
    
    # We create a hash of attributes for the route with any revised values.
    route_hash = {
      :current => current,
      :status => status,
      :parsed => parsed,
      :parse_pass_count => parse_pass_count,
      :source_step_name => source_step_name,
      :source_step_type => source_step_type,
      :target_step_name => target_step_name,
      :target_step_type => target_step_type
    }
    
    # We push this back into the hash of routes, keyed off the route.
    @routes[route] = route_hash
  end
end
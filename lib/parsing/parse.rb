# # Module containing the main parsing code: creation, initialisation and updating a hash for each route.
# Design notes for the [parsing of a procedure map with logic gates are here](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#procedure-maps-with-logic-gates).
module PARSE
  
  # ## Method to parse a route.
   # We pass in the route to be parsed, the source step of that route and the procedure the route is in.
   # The procedure is passed in to ensure that we only parse routes in that particular procedure.
   # This is necessary because we may encounter steps that are attached to routes in other procedures.
   def parse_route( route, source_step, procedure )
    
    # A route being parsed as part of the set of routes originating from a start step may have already been parsed, because a route subsequent to one of the routes from the start step may have that start step as its target.
    # We only wish to parse a route if it has not already been parsed.
    # Unless this route has been parsed ...
    unless @routes[route][:parsed] == true
      
      # ... we increment the parse pass count for this route, ...
      parse_pass_count = @routes[route][:parse_pass_count] + 1
      
      # ... update the route hash with that count ...
      update_route_hash( route, nil, nil, nil, parse_pass_count, nil, nil, nil, nil )
      
      # ... and increment the total parse pass count.
      @parse_pass_count += 1
      
      # ... the route and its attributes are logged.
      @parse_log << "Parsing route from #{@routes[route][:source_step_name]} (#{@routes[route][:source_step_type]}) to #{@routes[route][:target_step_name]} (#{@routes[route][:target_step_type]}) [#{@parse_pass_count}/#{@route_count}]."
  
      # ... we get the inbound routes to the source step of the route we're parsing in this procedure.
      inbound_routes = source_step.inbound_routes_in_procedure( procedure )
  
      # ### We check the type of the source step of the route we're parsing and parse the route accordingly.
      case @routes[route][:source_step_type]
      when "Business step"
        parse_route_from_business_step( route, source_step, procedure, inbound_routes )
      when "Decision"
        parse_route_from_decision_step( route, source_step, procedure, inbound_routes )
      when "NOT"
        parse_route_from_not_step( route, source_step, procedure, inbound_routes )
      when "AND"
        parse_route_from_and_step( route, source_step, procedure, inbound_routes )
      when "OR"
        parse_route_from_or_step( route, source_step, procedure, inbound_routes )
      end
      
      # ### We check the currency of the route.
      # Regardless of the type of the source step of the route we know that some routes are not current.
      parse_route_currency( route )
      
      # ### We assign the potential state of any target business step.
      assign_potential_business_step_state( route)
      
      # ### We continue to traverse the graph by following outbound routes from the target step of this route.
      # This forces a depth first traversal of the procedure.
  
      # We get the target step of the route we're parsing.
      target_step = route.target_step
  
      # For each outbound route, in the same procedure, from the target step of the route ...
      target_step.outbound_routes_in_procedure( procedure ).each do |outbound_route|
    
        # ... unless that route has already been parsed ...
        unless @routes[outbound_route][:parsed] == true
    
          # ... we parse the route.
          parse_route( outbound_route, target_step, procedure )
        end
      end
    end
  end
  
  # ## Method to initialise a hash of a hash of route attributes keyed off the route.
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
  
  
  
  # Edited to here

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
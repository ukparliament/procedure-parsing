# # Module containng the main parsing code including initialisation of the route hash, creation of a hash per route and updating of a hash per route.
# Design notes for the [parsing of a procedure map with logic gates are here](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#procedure-maps-with-logic-gates).
module PARSE_FROM_START_STEPS
  
  # ## Method to parse a route.
  # We pass in the route to be parsed, the source step of that route and the procedure the route is in.
  # The procedure is passed to ensure that we only parse routes in that procedure as we continue to traverse.
  # This is necessary because we will encounter steps that are attached to routes in other procedures.
  def parse_route( route, source_step, procedure )
    
    # It's possible that a route being parsed as part of the set of routes originating from a start step has already been parsed as a result of a set of routes from the start step being cyclic back to the start step.
    # So, we only parse a route if it's already been parsed.
    # Unless this route has been parsed ...
    unless @routes[route][:parsed] == true
      
      # ... given we are parsing this route ...
      # ... we update it's parse pass count.
      parse_pass_count = @routes[route][:parse_pass_count] + 1
      
      # ... and update the route hash with the new parse pass count.
      update_route_hash( route, nil, nil, nil, parse_pass_count, nil, nil, nil, nil )
      
      # ... we're parsing a route so we increment the parse count.
      @parse_count += 1
  
      # ... we update the parse log with details of the route being parsed.
      @parse_log << "Parsing route from #{@routes[route][:source_step_name]} (#{@routes[route][:source_step_type]}) to #{@routes[route][:target_step_name]} (#{@routes[route][:target_step_type]})."
    
      # ... we tell the user which route we're parsing.
      puts "Parse pass #{@parse_count} over #{@route_count} routes - Parsing route from #{@routes[route][:source_step_name]} (#{@routes[route][:source_step_type]}) to #{@routes[route][:target_step_name]} (#{@routes[route][:target_step_type]})."
  
      # ... we get the inbound routes to the source step of the route we're parsing.
      inbound_routes = source_step.inbound_routes_in_procedure( procedure )
  
      # ... we check the type of the source step of the route we're parsing and parse it accordingly.
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
        
      # ## ... we check for route currency.
      # Regardless of the type of the source step of the route we know that some routes are not current.
      # A non-current route is one with a start date that is later than today or one with an end date that is today or earlier than today.
      # If the route is current...
      if route.current
    
        # ... we update the route current attribute to true.
        update_route_hash( route, 'TRUE', nil, nil, nil, nil, nil, nil, nil )
    
      # ... otherwise, if the route is not current ...
      else
    
        # ... we update the route current attribute to 'FALSE' and the route status attribute to 'UNTRAVERSABLE' ...
        # ... setting the route status to 'UNTRAVERSABLE' records that this route in not currently active and is used to infer that routes from this route are also not currently active.
        # ... we also record this route as parsed because we don't want to visit it and attempt to parse again.
        update_route_hash( route, 'FALSE', 'UNTRAVERSABLE', true, nil, nil, nil, nil, nil )
      end
    
      # ## ... we assign the potential state of any target business step.
      # If the route we're attempting to parse has been fully parsed ...
      if @routes[route][:parsed] == true
      
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
      
    # ## ... having parsed this route, we now want to continue to traverse the graph, following outbound routes from the target step of this route.
    # This forces us to traverse the procedure in a depth first fashion.
  
    # ... we get the target step of the route we're parsing.
    target_step = route.target_step
  
    # ... for each outbound route from the target step of the route we're parsing...
    # ... checking we only get routes in the same procedure ...
    target_step.outbound_routes_in_procedure( procedure ).each do |outbound_route|
    
      # ... if the route has not already been parsed ....
      unless @routes[outbound_route][:parsed] == true
        
        # ... if the outbound route is parseable ...
        if outbound_route.is_parseable?( procedure, @routes )
    
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
    
      # ... we tell the user that the work package cannot be parsed.
      puts "Work package #{work_package.id} is subject to the subject to the #{work_package.parliamentary_procedure.name} procedure. This procedure has no routes and therefore the work package cannot be parsed."
    
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
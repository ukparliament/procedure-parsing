# # Module containing the main parsing code.
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
    unless @routes[route.id][:parsed] == true
      
      # ... we increment the parse pass count for this route, ...
      parse_pass_count = @routes[route.id][:parse_pass_count] + 1
      
      # ... update the route hash with that count ...
      update_route_hash( route, nil, nil, nil, parse_pass_count )
      
      # ... and increment the total parse pass count.
      @parse_pass_count += 1
      
      # ... the route and its attributes are logged.
      @parse_log << "Parsing route from <strong>#{@routes[route.id][:route].source_step_name} (#{@routes[route.id][:route].source_step_type})</strong> to <strong>#{@routes[route.id][:route].target_step_name} (#{@routes[route.id][:route].target_step_type})</strong> [#{@parse_pass_count}/#{@route_count}]."
  
      # ... we get the inbound routes to the source step of the route we're parsing in this procedure.
      inbound_routes = source_step.inbound_routes_in_procedure( procedure )
  
      # ### We check the type of the source step of the route we're parsing and parse the route accordingly.
      # For each parse method we pass the route to be parsed, the source step of the route and the set of inbound routes. The parsed and status attributes of the inbound routes are used to determine if and how we should evaluate the step.
      case @routes[route.id][:route].source_step_type
      when "Business step"
        parse_route_from_business_step( route, source_step, inbound_routes )
      when "Decision"
        parse_route_from_decision_step( route, source_step, inbound_routes )
      when "NOT"
        parse_route_from_not_step( route, source_step, inbound_routes )
      when "AND"
        parse_route_from_and_step( route, source_step, inbound_routes )
      when "OR"
        parse_route_from_or_step( route, source_step, inbound_routes )
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
        unless @routes[outbound_route.id][:parsed] == true
    
          # ... we parse the route.
          parse_route( outbound_route, target_step, procedure )
        end
      end
    end
  end
end
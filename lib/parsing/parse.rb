# # Module containing the main parsing code.
# Design notes for the [parsing of a procedure map with logic gates are here](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#procedure-maps-with-logic-gates).
module PARSE
  
  # ## Method to parse a route.
  # We pass in the ID of the route to be parsed.
  def parse_route_with_id( route_id )
    
    # A route being parsed as part of the set of routes originating from a start step may have already been parsed, because a route subsequent to one of the routes from the start step may have that start step as its target.
    # We only wish to parse a route if it has not already been parsed.
    # Unless this route has been parsed ...
    unless @routes[route_id][:parsed] == true
      
      # ... we increment the parse pass count for this route, ...
      parse_pass_count = @routes[route_id][:parse_pass_count] + 1
      
      # ... update the route hash with that count ...
      update_route_hash( route_id, nil, nil, nil, parse_pass_count )
      
      # ... and increment the total parse pass count.
      @parse_pass_count += 1
      
      # ... the route and its attributes are logged.
      @parse_log << "Parsing route from <strong>#{@routes[route_id][:route].source_step_name} (#{@routes[route_id][:route].source_step_type})</strong> to <strong>#{@routes[route_id][:route].target_step_name} (#{@routes[route_id][:route].target_step_type})</strong> [#{@parse_pass_count}/#{@route_count}]."
      
      # ... we get the IDs of the inbound routes to the source step of the route we're parsing.
      inbound_route_ids = @routes_to_steps[@routes[route_id][:route][:from_step_id]].inspect
  
      # ### We check the type of the source step of the route we're parsing and parse the route accordingly.
      # For each parse method we pass the ID of the route to be parsed. The parsed and status attributes of the inbound routes are used to determine if and how we should evaluate the step.
      case @routes[route_id][:route].source_step_type
      when "Business step"
        parse_route_from_business_step( route_id )
      when "Decision"
        parse_route_from_decision_step( route_id )
      when "NOT"
        parse_route_from_not_step( route_id )
      when "AND"
        parse_route_from_and_step( route_id )
      when "OR"
        parse_route_from_or_step( route_id )
      end
      
      # ### We check the currency of the route.
      # Regardless of the type of the source step of the route we know that some routes are not current.
      parse_route_currency( route_id )
      
      # ### We assign the potential state of any target business step.
      assign_potential_business_step_state( route_id )
      
      # ### We continue to traverse the graph by following outbound routes from the target step of this route.
      # This forces a depth first traversal of the procedure.
      # For each outbound route, in the same procedure, from the target step of the route ...
      
      # why is this here???????????
      if @routes_from_steps[@routes[route_id][:route].to_step_id]
      @routes_from_steps[@routes[route_id][:route].to_step_id].each do |outbound_route_id|
        
        # ... unless that route has already been parsed ...
        unless @routes[outbound_route_id][:parsed] == true
          
          # ... we parse the route.
          parse_route_with_id( outbound_route_id )
        end
      end
    end
    end
  end
end
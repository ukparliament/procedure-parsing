# # Module containing the main parsing code.
# Design notes for the [parsing of a procedure map with logic gates are here](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#procedure-maps-with-logic-gates).
module PARSE
  
  # ## Method to parse a route.
  # We pass in the ID of the route to be parsed.
  def parse_route_with_id( route_id )
    
    # A route being parsed as one of the set of routes originating from a start step may have already been parsed, because a route subsequent to one of the routes from that start step may have that start step as its target. We want to parse a route only if it has not already been parsed.
    # Unless this route has been parsed ...
    unless route_parsed_attribute( route_id ) == true
      
      # ... we increment the parse pass count for this route, ...
      parse_pass_count = route_parse_pass_count_attribute( route_id ) + 1
      
      # ... we update the route hash with that count ...
      update_route_hash( route_id, nil, nil, nil, nil, parse_pass_count )
      
      # ... and increment the total parse pass count.
      @parse_pass_count += 1
      
      # The route and its attributes are logged.
      @parse_log << "Parsing route from <strong>#{route_source_step_name( route_id )} (#{route_source_step_type( route_id )})</strong> to <strong>#{route_target_step_name( route_id )} (#{route_target_step_type( route_id )})</strong> [#{@parse_pass_count}/#{@route_count}]."
      
      # ### We parse the route according to the type of the source step.
      # For each parse method we pass the ID of the route to be parsed.
      case route_source_step_type( route_id )
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
      when "SUM"
        parse_route_from_sum_step( route_id )
      when "INCREMENT"
        parse_route_from_increment_step( route_id )
      when "EQUALS"
        parse_route_from_equals_step( route_id )
      when "SUMMATION"
        parse_route_from_summation_step( route_id )
      end
      
      # ### We check the currency of the route.
      # Regardless of the type of the source step of the route we know that some routes are not current.
      parse_route_currency( route_id )
      
      # ### We assign the potential state of any target business step.
      assign_potential_business_step_state( route_id )
      
      # ### We continue to traverse the graph by following outbound routes from the target step of this route.
      # This forces a depth first traversal of the procedure.
      # If the target step of the route we're parsing has outbound routes ...
      if step_outbound_routes( route_target_step_id( route_id ) )
        
        # ... for each outbound route from the target step of the route ...
        step_outbound_routes( route_target_step_id( route_id ) ).each do |outbound_route_id|
        
          # ... unless that route has already been parsed ...
          unless route_parsed_attribute( outbound_route_id ) == true
            
            # ... we parse the route.
            parse_route_with_id( outbound_route_id )
          end
        end
      end
    end
  end
end
# Module to assign a potential state to a business step.

module PARSE_ASSIGN_POTENTIAL_BUSINESS_STEP_STATE
## Method to assign a [potential state](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#potential-states-of-a-business-step) to a business step, being the target of a successfully parsed route.

  def assign_potential_business_step_state( route_id )
If the route we're attempting to parse has been successfully parsed ...

    if route_parsed_attribute( route_id ) == true
... we write to the parse log, reporting the route's parsed status.

      @parse_log << "Successfully parsed as <strong>#{route_status_attribute( route_id )}</strong>."
... if the target step of the route we've parsed is a business step ...

      if route_target_step_type( route_id ) == 'Business step'
### We check the status of the route we've parsed.

        case route_status_attribute( route_id )
When the status of the route we've parsed is 'TRUE' ...

        when "TRUE"
... we add the target step to the array of caused steps.

          @caused_steps << route_target_step( route_id )
When the status of the route we've parsed is 'ALLOWS' ...

        when "ALLOWS"
... we add the target step to the array of allowed steps.

          @allowed_steps << route_target_step( route_id )
When the status of the route we've parsed is either 'FALSE' or 'NULL' ...

        when "FALSE", "NULL"
... we add the target step to the array of disallowed as yet steps.

          @disallowed_as_yet_steps << route_target_step( route_id )
When the status of the route we've parsed is 'UNTRAVERSABLE' ...

        when "UNTRAVERSABLE"
... we add the target step to the array of disallowed now steps.

          @disallowed_now_steps << route_target_step( route_id )
Otherwise, if the status of the route we've parsed is neither 'TRUE', 'ALLOWS', 'FALSE', 'NULL' or 'UNTRAVERSABLE' ...

        else
... we write to the parse log, reporting that the successfully parsed route has an unexpected status.

          @parse_log << "Unexpected status of <strong>#{route_status_attribute( route_id )}</strong>."
        end
      end
    end
  end
end
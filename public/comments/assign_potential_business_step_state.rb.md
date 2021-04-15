# Module to assign a potential state to a business step.

module PARSE_ASSIGN_POTENTIAL_BUSINESS_STEP_STATE
## Method to assign a [potential state](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#potential-states-of-a-business-step) to a business step, being the target of a successfully parsed route.

  def assign_potential_business_step_state( route )
If the route we're attempting to parse has been successfully parsed ...

    if @routes[route][:parsed] == true
... we write to the parse log, reporting the route's parsed status.

      @parse_log << "Successfully parsed as <strong>#{@routes[route][:status]}</strong>."
... if the target step of the route we've parsed is a business step ...

      if route.target_step.step_type_name == 'Business step'
### We check the status of the route we've parsed.

        case @routes[route][:status]
When the status of the route we've parsed is 'TRUE' ...

        when "TRUE"
... we add the target step to the array of caused steps.

          @caused_steps << route.target_step
When the status of the route we've parsed is 'ALLOWS' ...

        when "ALLOWS"
... we add the target step to the array of allowed steps.

          @allowed_steps << route.target_step
When the status of the route we've parsed is either 'FALSE' or 'NULL' ...

        when "NULL", "FALSE"
... we add the target step to the array of disallowed as yet steps.

          @disallowed_as_yet_steps << route.target_step
When the status of the route we've parsed is 'UNTRAVERSABLE' ...

        when "UNTRAVERSABLE"
... we add the target step to the array of disallowed now steps.

          @disallowed_now_steps << route.target_step
Otherwise, if the status of the route we've parsed is neither 'TRUE', 'ALLOWS', 'FALSE', 'NULL' or 'UNTRAVERSABLE' ...

        else
... we write to the parse log, reporting that the successfully parsed route has an unexpected status.

          @parse_log << "Unexpected status of <strong>#{@routes[route][:status]}</strong>."
        end
      end
    end
  end
end
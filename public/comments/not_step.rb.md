# Module to parse a route whose source step is a NOT step.

module PARSE_NOT_STEP
## Method to parse a route whose source step is a NOT step.

  def parse_route_from_not_step( route, source_step, inbound_routes )
Design note: The [method used](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#validating-inputs-and-outputs-to-steps) for validating the number of input and output routes for each step type.

If the NOT step does not have one inbound route ...

    if inbound_routes.size != 1
... log the step as has having an unexpected number of inbound routes.

      logger.error "NOT step with ID #{source_step.id} has #{inbound_routes.size} inbound routes."
Otherwise, if the NOT step does have one inbound route ...

    else
... if the inbound route to the source step has been parsed ....

      if @routes[inbound_routes[0]][:parsed] == true
... we update the route parsed attribute to true.

        update_route_hash( route, nil, nil, true, nil )
... we refer to the [NOT step truth table](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#truth-table-not) ...

... we check the status of the inbound route to the source step.

        case @routes[inbound_routes[0]][:status]
When the status of the inbound route to the source step is 'TRUE' ...

        when 'TRUE'
... we set the status of this route to 'FALSE'.

          update_route_hash( route, nil, 'FALSE', nil, nil )
When the status of the inbound route to the source step is 'FALSE' ...

        when 'FALSE'
... we set the status of this route to 'TRUE'.

          update_route_hash( route, nil, 'TRUE', nil, nil )
Otherwise, when the status of the inbound route is neither ‘TRUE’ nor ‘FALSE’ ...

        else
... we set the status of this route to the status of the inbound route.

          update_route_hash( route, nil, @routes[inbound_routes[0]][:status], nil, nil )
        end
Otherwise, the inbound route is not parsed and will be parsed on a later pass.

      end
    end
  end
end
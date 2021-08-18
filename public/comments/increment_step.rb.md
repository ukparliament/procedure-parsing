# Module to parse a route whose source step is an INCREMENT step.

module PARSE_INCREMENT_STEP
## Method to parse a route whose source step is an INCREMENT step.

  def parse_route_from_increment_step( route_id )
Design note: The [method used](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/with-step-types/#validating-inputs-and-outputs-to-steps) for validating the number of input and output routes for each step type.

If the INCREMENT step does not have one inbound route ...

    if step_inbound_routes( route_source_step_id( route_id ) ).size != 1
... log the step as has having an unexpected number of inbound routes.

      logger.error "INCREMENT step with name #{route_source_step_name( route_id )} has #{step_inbound_routes( route_source_step_id( route_id ) ).size} inbound routes."
Otherwise, the INCREMENT step does have one inbound route ...

    else
... we get the ID of the first - and in this case only - inbound route.

      inbound_route_id = step_first_inbound_route( route_source_step_id( route_id ) )
If the inbound route to the source step has been parsed ...

      if route_parsed_attribute( inbound_route_id ) == true
... we update the route parsed attribute to true.

        update_route_hash( route_id, nil, nil, true, nil, nil )
Referring to the [design notes for artithmetic steps](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/with-step-types/#arithmetic-steps) ...

... if the inbound route to the source step has a status of 'UNTRAVERSABLE' ...

        if route_is_untraversable?( inbound_route_id )
... we set the status of this route to 'UNTRAVERSABLE' ...

... tainting the roads off the bridge as closed if the bridge is closed.

          update_route_hash( route_id, nil, 'UNTRAVERSABLE', nil, nil, nil )
Otherwise, the inbound route to the source step does not have a status of 'UNTRAVERSABLE' ...

        else
... and we get the actualisation count of the inbound route, ...

          actualisation_count = route_actualisation_count( inbound_route_id )
... increment it by 1 ...

          increment = actualisation_count + 1
... and set the actualisation count of this route to the incremented value.

          update_route_hash( route_id, nil, nil, nil, increment, nil )
        end
Otherwise, the inbound route is not parsed and will be parsed on a later pass.

      end
    end
  end
end
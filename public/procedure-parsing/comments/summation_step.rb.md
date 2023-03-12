# Module to parse a route whose source step is a summation step.

module PARSE_SUMMATION_STEP
## Method to parse a route whose source step is a summation step.

  def parse_route_from_summation_step( route_id )
Design note: The [method used](https://ukparliament.github.io/ontologies/procedure/maps/meta/design-notes/#validating-inputs-and-outputs-to-steps) for validating the number of input and output routes for each step type.

If the summation step does not have one inbound route ...

    if step_inbound_routes( route_source_step_id( route_id ) ).size != 1
... log the step as has having an unexpected number of inbound routes.

      logger.error "Summation step with name #{route_source_step_name( route_id )} has #{step_inbound_routes( route_source_step_id( route_id ) ).size} inbound routes."
Otherwise, the summation step does have one inbound route ...

    else
... and we get the ID of the first - and in this case only - inbound route.

      inbound_route_id = step_first_inbound_route( route_source_step_id( route_id ) )
### If the inbound route to the source step has been parsed ...

      if route_parsed_attribute( inbound_route_id ) == true
... we update the route parsed attribute to true.

        update_route_hash( route_id, nil, nil, true, nil, nil )
Referring to the [design notes for summation steps](https://ukparliament.github.io/ontologies/procedure/maps/meta/design-notes/#summation-steps) ...

... we get the ‘current’, ‘status’, ‘parsed’ and ‘actualisation count’ attributes of the inbound route ...

        current = route_current_attribute( inbound_route_id )
        status = route_status_attribute( inbound_route_id )
        parsed = route_parsed_attribute( inbound_route_id )
        actualisation_count = route_actualisation_count( inbound_route_id )
... and set these attributes of this route to those of the inbound route.

        update_route_hash( route_id, current, status, parsed, actualisation_count, nil )
### Otherwise, the inbound route is not parsed and will be parsed on a later pass.

      end
    end
  end
end
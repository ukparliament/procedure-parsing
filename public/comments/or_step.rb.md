# Module to parse a route whose source step is an OR step.

module PARSE_OR_STEP
## Method to parse a route whose source step is an OR step.

  def parse_route_from_or_step( route_id )
Design note: The [method used](https://ukparliament.github.io/ontologies/procedure/maps/meta/design-notes/#validating-inputs-and-outputs-to-steps) for validating the number of input and output routes for each step type.

If the OR step does not have two inbound routes ...

    if step_inbound_routes( route_source_step_id( route_id ) ).size != 2
... log the step as has having an unexpected number of inbound routes.

      logger.error "OR step with name #{route_source_step_name( route_id )} has #{step_inbound_routes( route_source_step_id( route_id ) ).size} inbound routes."
The appearance of inbound routes in first or second place has no meaning beyond the order they are delivered from the data store.

Otherwise, the OR step does have two inbound routes.

    else
We get the ID of the first inbound route ...

      first_inbound_route_id =  step_first_inbound_route( route_source_step_id( route_id ) )
... we get the ID of the second inbound route.

      second_inbound_route_id = step_second_inbound_route( route_source_step_id( route_id ) )
### If both inbound routes to the source step have been parsed ....

      if route_parsed_attribute( first_inbound_route_id ) == true and route_parsed_attribute( second_inbound_route_id ) == true
... we update the route parsed attribute to true.

        update_route_hash( route_id, nil, nil, true, nil, nil )
We refer to the [OR step truth table](https://ukparliament.github.io/ontologies/procedure/maps/meta/design-notes/#or-steps) ...

... and if either inbound route to the source step has a status of 'TRUE' ...

        if route_status_attribute( first_inbound_route_id ) == 'TRUE' or route_status_attribute( second_inbound_route_id ) == 'TRUE'
... we set the status of this route to 'TRUE'.

          update_route_hash( route_id, nil, 'TRUE', nil, nil, nil )
Otherwise, if either inbound route to the source step has a status of 'UNTRAVERSABLE' ...

        elsif route_is_untraversable?( first_inbound_route_id ) or route_is_untraversable?( second_inbound_route_id )
... we set the status of this route to 'UNTRAVERSABLE' ...

... tainting the roads off the bridge as closed if the bridge is closed.

          update_route_hash( route_id, nil, 'UNTRAVERSABLE', nil, nil, nil )
Otherwise, if either inbound route has a status of 'FALSE' ...

        elsif route_status_attribute( first_inbound_route_id ) == 'FALSE' or route_status_attribute( second_inbound_route_id ) == 'FALSE'
... we set the status of this route to 'FALSE'.

          update_route_hash( route_id, nil, 'FALSE', nil, nil, nil )
        end
### Otherwise if the first inbound route has been parsed and the second inbound route has not been parsed ....

      elsif route_parsed_attribute( first_inbound_route_id ) == true and route_parsed_attribute( second_inbound_route_id ) == false
... we do not update the parsed attribute to true, meaning this route will be parsed again on a later pass ...

... and we set the status of this route to the status of the first inbound route.

        update_route_hash( route_id, nil, route_status_attribute( first_inbound_route_id ), nil, nil, nil )
### Otherwise if the first inbound route has not been parsed and the second inbound route has been parsed ....

      elsif route_parsed_attribute( first_inbound_route_id ) == false and route_parsed_attribute( second_inbound_route_id ) == true
... we do not update the parsed attribute to true, meaning this route will be parsed again on a later pass ...

... and we set the status of this route to the status of the second inbound route.

        update_route_hash( route_id, nil, route_status_attribute( second_inbound_route_id ), nil, nil, nil )
### Otherwise, neither inbound route has been parsed and this route will be parsed on a later pass.

      end
    end
  end
end
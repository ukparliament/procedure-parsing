# Module to parse a route whose source step is a business step.

module PARSE_BUSINESS_STEP
## Method to parse a route whose source step is a business step.

  def parse_route_from_business_step( route, source_step, inbound_routes )
Design note: The [method used](https://ukparliament.github.io/ontologies/procedure/flowcharts/meta/design-notes/#validating-inputs-and-outputs-to-steps) for validating the number of input and output route for each step type.

If the business step does not have one inbound route ...

    if inbound_routes.size != 1
... log the step as has having an unexpected number of routes.

      logger.error "Business step with ID #{source_step.id} has #{inbound_routes.size} inbound routes."
Otherwise, if the business step does have one inbound route ...

    else
... if the inbound route to the source step has a status of 'UNTRAVERSABLE' ...

      if @routes[inbound_routes[0]][:status] == 'UNTRAVERSABLE'
... then “the bridge is closed” and we set the “roads off the bridge” as closed ...

... by setting the status of this route to also be 'UNTRAVERSABLE' and the parsed attribute to true.

        update_route_hash( route, nil, 'UNTRAVERSABLE', true, nil )
... otherwise, the inbound route to the source step not having a status of 'UNTRAVERSABLE' ...

      else
... if the source step has been actualised by a business item with a date in the past or a date of today ...

        if source_step.actualised_has_happened_in_work_package?( @work_package )
... we set the route status to 'TRUE' and the parsed attribute to true.

          update_route_hash( route, nil, 'TRUE', true, nil )
... otherwise, the source step has not been actualised or has only been actualised by business items with dates in the past ....

        else
... and we set the route status to 'NULL' and the parsed attribute to true.

          update_route_hash( route, nil, 'NULL', true, nil )
        end
      end
    end
  end
end
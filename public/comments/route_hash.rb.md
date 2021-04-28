# Module to initialise, create and update a hash of a hash of route attributes keyed off the ID of a route.

module PARSE_ROUTE_HASH
## Method to initialise a hash of a hash of route attributes keyed off the ID of a route.

We use this to store values that are generated from parsing and are not on the route model.

  def initialise_route_hash( work_package )
We get all routes which appear in the procedure the work package is subject to, together with the name and type of the source step of each route and the name and type of the target step of each route.

    routes = work_package.parliamentary_procedure.routes_with_steps
We record the number of routes in the procedure as an instance variable, so we can use it to report progress.

    @route_count = routes.size
If the procedure has no routes ...

    if routes.empty?
... we write to the log, explaining that the work package cannot be parsed.

      @parse_log << "Work package #{work_package.id} is subject to the #{work_package.parliamentary_procedure.name} procedure. This procedure has no routes and therefore the work package cannot be parsed."
Otherwise, if the procedure does have routes ...

    else
... we create a hash for the routes and their attributes.

This is created as an instance variable because we want to write to it as we parse and report on it later.

      @routes = {}
... we loop through the routes and ...

      routes.each do |route|
... for each route create a hash of values we want to store for that route.

        route_hash = create_and_add_route_hash(
          route, # We pass in the route which we'll use as the key of the hash.
          'NULL', # We pass in the current attribute to capture if the route is currently active. This is 'NULL' until the route is parsed.
          'UNPARSED', # We pass in the status attribute of the route. This is 'UNPARSED' until the route is parsed.
          false, # We pass in the parsed attribute of the route. This is false until the route is successfully parsed. A route may have many parse passes before being successfully parsed.
          0, # We pass in the parse pass count attribute of this route. This is 0 until parsed.
        )
      end
    end
  end
## Method to create a hash of attributes for a route and to add the attributes hash to the containing routes hash.

  def create_and_add_route_hash( route, current, status, parsed, parse_pass_count )
We create a hash of route attributes.

    route_hash = {
      :current => current,
      :status => status,
      :parsed => parsed,
      :parse_pass_count => parse_pass_count,
      :route => route
    }
We add the hash to the routes hash, keyed off the ID of the route.

    @routes[route.id] = route_hash
  end
## Method to update the hash of attributes for a route within the containing route hash.

  def update_route_hash( route, current, status, parsed, parse_pass_count )
We check if this method has been passed a value for an attribute.

Where the method has been passed nil as an attribute value, we use the attribute value as it exists in the hash.

    current = current || @routes[route.id][:current]
    status = status || @routes[route.id][:status]
    parsed = parsed || @routes[route.id][:parsed]
    parse_pass_count = parse_pass_count || @routes[route.id][:parse_pass_count]
We create a hash of attributes for the route with any revised values.

    route_hash = {
      :current => current,
      :status => status,
      :parsed => parsed,
      :parse_pass_count => parse_pass_count,
      :route => @routes[route.id][:route]
    }
We push this back into the hash of routes, keyed off the ID of the route.

    @routes[route.id] = route_hash
  end
end
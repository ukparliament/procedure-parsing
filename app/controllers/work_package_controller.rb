class WorkPackageController < ApplicationController
  
  def show
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
  end
  
  def parse
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
    
    procedure = @work_package.parliamentary_procedure
    
    # Get all the routes in the procedure the work package is subject to.
    routes = @work_package.parliamentary_procedure.routes_with_steps
    
    # Create a hash to hold the routes and their attributes
    @routes = {}
    
    # Loop through the routes and ...
    routes.each do |route|
      
      # ... create a hash of values we want to store for the route
      route_hash = create_route_hash(
        route,
        'null',
        'unparsed',
        false,
        route.source_step_name,
        route.source_step_type,
        route.target_step_name,
        route.target_step_type
      )
    end
    
    # Get the start steps of the procedure the work package is subject to.
    start_steps = @work_package.parliamentary_procedure.start_steps
    
    # Loop through the start steps.
    start_steps.each do |step|
      step.outbound_routes_in_procedure( procedure ).each do |outbound_route|
        parse_route( step, outbound_route, procedure )
      end
    end
  end
end

def parse_route( source_step, route, procedure )
  update_route_hash( route, nil, nil, true, nil, nil, nil, nil)
  target_step = route.target_step
  
  target_step.outbound_routes_in_procedure( procedure ).each do |outbound_route|
    parse_route( target_step, outbound_route, procedure ) unless @routes[outbound_route][:parsed] == true
  end
end

# Method to create a hash of route attributes and add it to the route hash
def create_route_hash( route, current, status, parsed, source_step_name, source_step_type, target_step_name, target_step_type )
  # Create a hash of route attributes
  route_hash = {
    :current => current,
    :status => status,
    :parsed => parsed,
    :source_step_name => source_step_name,
    :source_step_type => source_step_type,
    :target_step_name => target_step_name,
    :target_step_type => target_step_type
  }
  # Add the hash to the routes hash keyed off the route
  @routes[route] = route_hash
end

# Method to update route attributes in the routes hash
def update_route_hash( route, current, status, parsed, source_step_name, source_step_type, target_step_name, target_step_type )
  current = current || @routes[route][:current]
  status = status || @routes[route][:status]
  parsed = parsed || @routes[route][:parsed]
  source_step_name = source_step_name || @routes[route][:source_step_name]
  source_step_type = source_step_type || @routes[route][:source_step_type]
  target_step_name = target_step_name || @routes[route][:target_step_name]
  target_step_type = target_step_type || @routes[route][:target_step_type]
  route_hash = {
    :current => current,
    :status => status,
    :parsed => parsed,
    :source_step_name => source_step_name,
    :source_step_type => source_step_type,
    :target_step_name => target_step_name,
    :target_step_type => target_step_type
  }
  @routes[route] = route_hash
end
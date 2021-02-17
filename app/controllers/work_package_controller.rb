# Individual parsing rules for steps types are are packaged into separate files. This code requires those files to be loaded.
require 'parsing/business_step'
require 'parsing/decision_step'
require 'parsing/not_step'
require 'parsing/and_step'
require 'parsing/or_step'

class WorkPackageController < ApplicationController
  
  # Include code from each of the modules for the different styles of parsing.
  include PARSING_BUSINESS_STEP
  include PARSING_DECISION_STEP
  include PARSING_NOT_STEP
  include PARSING_AND_STEP
  include PARSING_OR_STEP
  
  def show
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
  end
  
  # This method attempts to parse a procedure in the context of a work package.
  def parse
    
    # Set up an array to log the parsing
    @parse_log = []
    
    # Get the work package we're trying to parse.
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
    
    # Get the procedure the work package is subject to.
    procedure = @work_package.parliamentary_procedure
    
    # Initialise a hash of additional route attributes keyed off the route.
    initialise_route_hash( @work_package )
    
    # Get the start steps of the procedure the work package is subject to.
    start_steps = procedure.start_steps
    
    # Loop through the start steps.
    start_steps.each do |step|
      step.outbound_routes_in_procedure( procedure ).each do |route|
        parse_route( route, step, procedure )
      end
    end
  end
end

# Method to parse a route
# We pass in the route to be parsed, the source step of that route and the procedure the route is in
def parse_route( route, source_step, procedure )
  
  # Update the parse log with what's being parsed
  @parse_log << "Parsing route from #{@routes[route][:source_step_name]} (#{@routes[route][:source_step_type]}) to #{@routes[route][:target_step_name]} (#{@routes[route][:target_step_type]})"
  
  # Get inbound routes to the source step.
  inbound_routes = source_step.inbound_routes_in_procedure( procedure )
  
  # Check the type of the source step.
  case @routes[route][:source_step_type]
  when "Business step"
    parse_route_from_business_step( route, source_step, procedure, inbound_routes )
  when "Decision step"
    parse_route_from_decision_step( route, source_step, procedure, inbound_routes )
  when "NOT"
    parse_route_from_not_step( route, source_step, procedure, inbound_routes )
  when "AND"
    parse_route_from_and_step( route, source_step, procedure, inbound_routes )
  when "OR"
    parse_route_from_or_step( route, source_step, procedure, inbound_routes )
  end
  
  # If the route is current...
  if route.current
    
    # ... update the route current attribute to true
    update_route_hash( route, 'TRUE', nil, nil, nil, nil, nil, nil )
    
  # Otherwise, if the route is not current ...
  else
    
    # ... update the route current attribute to 'FALSE', the status attribute to 'UNTRAVERSABLE' and the parsed attribute to 'TRUE'
    update_route_hash( route, 'FALSE', 'UNTRAVERSABLE', true, nil, nil, nil, nil )
  end
  
  # Get the target step of the route.
  target_step = route.target_step
  
  # For each outbound route from the target step in this procedure ...
  target_step.outbound_routes_in_procedure( procedure ).each do |outbound_route|
    
    # If the route has not already been parsed ....
    unless @routes[outbound_route][:parsed] == true
      
      # ...parse the route.
      parse_route( outbound_route, target_step, procedure )
    end
  end
end






# Method to initialise a hash of route attributes keyed off the route.
def initialise_route_hash( work_package )
  
  # Get all the routes in the procedure the work package is subject to.
  routes = work_package.parliamentary_procedure.routes_with_steps
  
  # Create a hash to hold the routes and their attributes
  @routes = {}
  
  # Loop through the routes and ...
  routes.each do |route|
    
    # ... create a hash of values we want to store for the route
    route_hash = create_route_hash(
      route,
      'NULL',
      'UNPARSED',
      false,
      route.source_step_name,
      route.source_step_type,
      route.target_step_name,
      route.target_step_type
    )
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
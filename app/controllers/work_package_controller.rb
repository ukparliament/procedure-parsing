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
    routes = @work_package.parliamentary_procedure.routes
    
    # Create a hash to hold the routes and their attributes
    @routes = {}
    
    # Loop through the routes and...
    routes.each do |route|
      route_hash = { :current => 'null', :status => 'unparsed', :parsed => false }
      @routes[route] = route_hash
    end
    puts "@@@@@@"
    puts @routes.size
    
    # Get the start steps of the procedure the work package is subject to.
    start_steps = @work_package.parliamentary_procedure.start_steps
    
    # Loop through the start steps.
    start_steps.each do |step|
      step.outbound_routes_in_procedure( procedure ).each do |outbound_route|
        parse_route( outbound_route, procedure )
      end
    end
  end
end

def parse_route( route, procedure )
  puts route.triple_store_id
  current = @routes[route][:current]
  status = @routes[route][:status]
  parsed = @routes[route][:parsed]
  route_hash = { :current => current, :status => status, :parsed => true }
  @routes[route] = route_hash
  route.target_step.outbound_routes_in_procedure( procedure ).each do |outbound_route|
    parse_route( outbound_route, procedure ) unless @routes[outbound_route][:parsed] == true
  end
end
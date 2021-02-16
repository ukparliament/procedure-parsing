class WorkPackageController < ApplicationController
  
  def show
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
  end
  
  def parse
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
    
    # Get all the routes in the procedure the work package is subject to.
    routes = @work_package.parliamentary_procedure.routes
    # Loop through the routes and...
    routes.each do |route|
      route.current = 'null'
      route.status = 'null'
      route.parsed = false
    end
    
    # Get the start steps of the procedure the work package is subject to.
    start_steps = @work_package.parliamentary_procedure.start_steps
    
    # Loop through the start steps.
    start_steps.each do |step|
      step.outbound_routes.each do |outbound_route|
        parse_route( outbound_route )
      end
    end
  end
end

def parse_route( route )
  route.parsed = true
  route.target_step.outbound_routes.each do |outbound_route|
    #parse_route( outbound_route ) unless outbound_route.parsed == true
  end
end
# The main parsing code and the individual parsing rules for source steps types are packaged into separate files.
# We require the main parsing code and the step type specific parsing code to be loaded.
require "#{Rails.root}/lib/parsing/from-business-steps/parse"
require "#{Rails.root}/lib/parsing/from-business-steps/and_step"
require "#{Rails.root}/lib/parsing/from-business-steps/business_step"
require "#{Rails.root}/lib/parsing/from-business-steps/decision_step"
require "#{Rails.root}/lib/parsing/from-business-steps/not_step"
require "#{Rails.root}/lib/parsing/from-business-steps/or_step"

class WorkPackageController < ApplicationController
  
  # We include code for the different styles of parsing according to the source step type.
  include PARSE
  include PARSE_BUSINESS_STEP
  include PARSE_DECISION_STEP
  include PARSE_NOT_STEP
  include PARSE_AND_STEP
  include PARSE_OR_STEP
  
  def show
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
    parse
  end
  
  # This method attempts to parse a procedure in the context of a work package.
  def parse
    
    # We get the work package we're trying to parse.
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
  
    # We get the procedure the work package is subject to.
    procedure = @work_package.parliamentary_procedure
  
    # We tell the user what we're attempting to do.
    puts "Attempting to parse work package #{@work_package.id}, subject to the #{procedure.name.downcase} procedure."
    
    # We set up an array to log the parsing.
    # Create as an instance variable because we want to write to and from it later.
    @parse_log = []
  
    # We create a set of arrays to store the target business steps of the routes we parse according to the value of the inbound route once parsed.
    # Created as instance variables because we want to write to and from them later.
    @caused_steps = []
    @allowed_steps = []
    @disallowed_yet_steps = []
    @disallowed_now_steps = []
  
    # We initialise a hash of additional route attributes keyed off the route.
    initialise_route_hash( @work_package )
  
    # We set the parse count to zero.
    # This will be incremented every time we parse a route and used for reporting.
    # Created as an instance variable because we want to increment on each parse and report on it later.
    @parse_count = 0
  
    # We get the all the business in the procedure the work package is subject to.
    business_steps = procedure.business_steps
  
    # We loop through the business steps ...
    business_steps.each do |step|
    
      # ... and loop through the outbound routes of each business step ...
      step.outbound_routes_in_procedure( procedure ).each do |route|
      
        # ... and parse each route.
        parse_route( route, step, procedure )
      end
    end
  end
end
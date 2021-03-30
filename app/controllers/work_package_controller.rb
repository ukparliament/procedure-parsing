# The main parsing code and the individual parsing rules for source steps types are packaged into separate files.
# We require the main parsing code and the step type specific parsing code to be loaded.
require "#{Rails.root}/lib/parsing/parse"
require "#{Rails.root}/lib/parsing/and_step"
require "#{Rails.root}/lib/parsing/business_step"
require "#{Rails.root}/lib/parsing/decision_step"
require "#{Rails.root}/lib/parsing/not_step"
require "#{Rails.root}/lib/parsing/or_step"

class WorkPackageController < ApplicationController
  
  ## We include code for the different styles of parsing according to the source step type.
  include PARSE
  include PARSE_BUSINESS_STEP_FROM_START_STEPS
  include PARSE_DECISION_STEP_FROM_START_STEPS
  include PARSE_NOT_STEP_FROM_START_STEPS
  include PARSE_AND_STEP_FROM_START_STEPS
  include PARSE_OR_STEP_FROM_START_STEPS
  
  def show
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
    parse
  end
  
  ## This method attempts to parse a work package subject to a procedure.
  def parse
    
    # We get the work package we're attempting to parse.
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
  
    # We get the procedure the work package is subject to.
    procedure = @work_package.parliamentary_procedure
  
    # We set the parse count to zero.
    # This will be incremented every time we parse a route and used for reporting.
    # The parse count is created as an instance variable because we want to increment on each parse and report from it later.
    @parse_count = 0
    
    # We set up an array to log the parsing.
    # The log is created as an instance variable because we want to write to it and report from it later.
    @parse_log = []
    
    # We write to the log, explaining what we're attempting to do.
    @parse_log << "Attempting to parse work package #{@work_package.id}, subject to the #{procedure.name.downcase} procedure."
    
    # We create a set of arrays to store the target business steps of the routes we parse according to the status of the inbound route once parsed.
    # Theese are created as instance variables because we want to write to then and report from them later.
    @caused_steps = []
    @allowed_steps = []
    @disallowed_yet_steps = []
    @disallowed_now_steps = []
  
    # We initialise a hash of route attributes keyed off the route.
    # This is used to store the progress and results of the route parsing for each route in the procedure.
    initialise_route_hash( @work_package )
    
    # We get an array of the start steps in the procedure the work package is subject to.
    # The array is created as an instance variable because we want to check it when parsing business steps.
    @start_steps = procedure.start_steps
  
    # We loop through the start steps in the procedure ...
    @start_steps.each do |step|
    
      # ... loop through the outbound routes of each start step ...
      step.outbound_routes_in_procedure( procedure ).each do |route|
    
        # ... and parse each route.
        parse_route( route, step, procedure )
      end
    end
  end
end
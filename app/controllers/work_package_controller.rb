# The main parsing code and the individual parsing rules for source steps types are packaged into separate files.
# We require the main parsing code to be loaded ...
require "#{Rails.root}/lib/parsing/parse"

# ... together with the code for parsing specific step types ...
require "#{Rails.root}/lib/parsing/and_step"
require "#{Rails.root}/lib/parsing/business_step"
require "#{Rails.root}/lib/parsing/decision_step"
require "#{Rails.root}/lib/parsing/not_step"
require "#{Rails.root}/lib/parsing/or_step"
require "#{Rails.root}/lib/parsing/sum_step"
require "#{Rails.root}/lib/parsing/increment_step"
require "#{Rails.root}/lib/parsing/equals_step"
require "#{Rails.root}/lib/parsing/summation_step"

# ... and the code for storing route attributes, determining route currency and assigning potential step states.
require "#{Rails.root}/lib/parsing/route_hash"
require "#{Rails.root}/lib/parsing/step_hash"
require "#{Rails.root}/lib/parsing/route_currency"
require "#{Rails.root}/lib/parsing/assign_potential_business_step_state"

# # Work package controller
class WorkPackageController < ApplicationController
  
  # We include code for the main parsing rules ...
  include PARSE
  
   # ... together with code for the different styles of parsing according to the type of the source step ...
  include PARSE_BUSINESS_STEP
  include PARSE_DECISION_STEP
  include PARSE_NOT_STEP
  include PARSE_AND_STEP
  include PARSE_OR_STEP
  include PARSE_SUM_STEP
  include PARSE_INCREMENT_STEP
  include PARSE_EQUALS_STEP
  include PARSE_SUMMATION_STEP
  
  # ... and the code for storing route attributes, determining route currency and assigning potential step states.
  include PARSE_ROUTE_HASH
  include PARSE_STEP_HASH
  include PARSE_ROUTE_CURRENCY
  include PARSE_ASSIGN_POTENTIAL_BUSINESS_STEP_STATE
  
  
  # ## We show the work package including:
  # * steps with a current state of happened, scheduled to happen and actualised with a business item with no date
  # * steps with a potential state as determined by the parsing code
  def show
    
    # We parse the work package, also getting the work package object.
    parse
    
    # We get business steps actualised as having happened, being scheduled to happen or being actualised with no date.
    @business_items_that_have_happened = @work_package.business_items_that_have_happened
    @business_items_that_are_scheduled_to_happen = @work_package.business_items_that_are_scheduled_to_happen
    @business_items_unknown = @work_package.business_items_unknown
    
    # We need to calculate the occurrence score of potential steps.
    # We get all concluded work packages subject to this procedure ...
    @concluded_work_packages = @procedure.concluded_work_packages
    
    # ... and call bicamerally concluded work packages subject to this procedure.
    @bicamerally_concluded_work_packages = @procedure.bicamerally_concluded_work_packages
  end
  
  # ## We display a log of the parse passes.
  def log
    parse
  end
  
  # ## We display a visualisation of the parse passes.
  def visualise
    parse
  end
  
  # ## This method attempts to parse a work package subject to a procedure.
  # By taking actualised and non-actualised business steps and parsing the logical procedure map, we aim to determine business steps that may happen, should happen or should not happen in the future.
  def parse
    
    # We get the work package we're attempting to parse.
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
  
    # We get the procedure the work package is subject to.
    # The procedure is stored as an instance variable because we want to report from it later.
    @procedure = @work_package.parliamentary_procedure
  
    # We set the parse pass count to zero.
    # The parse pass count will be incremented every time we attempt to parse a route.
    # The parse pass count is created as an instance variable because we want to increment on each parse pass and report from it later.
    @parse_pass_count = 0
    
    # We create an array to log the parsing.
    # The log is created as an instance variable because we want to write to it and report from it later.
    @parse_log = []
    
    # We write to the log, explaining what we're attempting to do.
    @parse_log << "Attempting to parse work package #{@work_package.id}, subject to the #{@procedure.name.downcase} procedure."
    
    # Having successfully parsed a route to a business step, we can determine the [potential state](https://ukparliament.github.io/ontologies/procedure/maps/meta/design-notes/#potential-states-of-a-business-step) of that business step. The potential state of a business state may be caused to be actualised, allowed to be actualised, not yet actualisable or not now actualisable.
    # We create a set of arrays to store the target business steps of the routes we successfully parse - each array being named according to the potential state of the target step.
    # These are created as instance variables because we want to write to them and report from them later.
    @caused_steps = []
    @allowed_steps = []
    @disallowed_as_yet_steps = []
    @disallowed_now_steps = []
  
    # We initialise a hash of additional route attributes: these are attributes are used only during the parsing process.
    initialise_route_hash( @work_package )
  
    # We initialise a hash of steps keyed off the step ID together with a hash of IDs of outbound routes from a step and a hash of IDs of inbound routes to a step, also keyed off the step ID.
    initialise_step_hashes( @procedure )
    
    # We get an array of the start steps in the procedure.
    start_steps = @procedure.start_steps
  
    # We loop through the start steps in the procedure ...
    start_steps.each do |step|
      
      # ... then loop through the outbound routes of each start step ...
      step_outbound_routes( step.id ).each do |route_id|
        
        # ... and parse each of those routes, passing in the ID of the route.
        parse_route_with_id( route_id )
      end
    end
  end
end
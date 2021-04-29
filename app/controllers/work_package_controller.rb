# The main parsing code and the individual parsing rules for source steps types are packaged into separate files.
# We require the main parsing code to be loaded ...
require "#{Rails.root}/lib/parsing/parse"

# ... together with the code for parsing specific step types ...
require "#{Rails.root}/lib/parsing/and_step"
require "#{Rails.root}/lib/parsing/business_step"
require "#{Rails.root}/lib/parsing/decision_step"
require "#{Rails.root}/lib/parsing/not_step"
require "#{Rails.root}/lib/parsing/or_step"

# ... and the code for storing route attributes, determining route currency and assigning potential step states.
require "#{Rails.root}/lib/parsing/route_hash"
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
  
  # ... and the code for storing route attributes, determining route currency and assigning potential step states.
  include PARSE_ROUTE_HASH
  include PARSE_ROUTE_CURRENCY
  include PARSE_ASSIGN_POTENTIAL_BUSINESS_STEP_STATE
  
  def show
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
    parse
  end
  
  # ## This method attempts to parse a work package subject to a procedure.
  # By taking actualised and non-actualised business steps and parsing the logical procedure map, we aim to determine business steps that may happen, should happen or should not happen in the future.
  def parse
    
    # We get the work package we're attempting to parse.
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
  
    # We get the procedure the work package is subject to.
    procedure = @work_package.parliamentary_procedure
  
    # We set the parse pass count to zero.
    # The parse pass count will be incremented every time we attempt to parse a route.
    # The parse pass count is created as an instance variable because we want to increment on each parse and report from it later.
    @parse_pass_count = 0
    
    # We create an array to log the parsing.
    # The log is created as an instance variable because we want to write to it and report from it later.
    @parse_log = []
    
    # We write to the log, explaining what we're attempting to do.
    @parse_log << "Attempting to parse work package #{@work_package.id}, subject to the #{procedure.name.downcase} procedure."
    
    # Having successfully parsed a route to a business step, we can determine the potential state of that business step. The potential state of a business state may be caused to be actualised, allowed to be actualised, not yet actualisable or not now actualisable.
    # We create a set of arrays to store the target business steps of the routes we successfully parse - each array being named according to the potential state of the target step.
    # These are created as instance variables because we want to write to them and report from them later.
    @caused_steps = []
    @allowed_steps = []
    @disallowed_as_yet_steps = []
    @disallowed_now_steps = []
  
    # We initialise a hash of additional route attributes: these are attributes used only during the parsing process.
    initialise_route_hash( @work_package )
    
    ### ==========
  
    # We initialise a hash of steps keyed off the step ID together with a hash of outbound routes from a step and inbound routes to a step, also keyed off the step ID.
    initialise_step_hashes( procedure )
    
    ### ==========
    
    # We get an array of the start steps in the procedure.
    # The array is created as an instance variable because we want to check it when parsing business steps.
    @start_steps = procedure.start_steps
  
    # We loop through the start steps in the procedure ...
    @start_steps.each do |step|
      
      # ... then loop through the outbound routes of each start step ...
      step.outbound_route_ids( @routes_from_steps ).each do |route_id|
    
        ### ==========
        # ... and parse each of those routes, passing in the ID of the route .
        parse_route_with_id( route_id )
        ### ==========
      end
    end
  end
end

### =========

def initialise_step_hashes( procedure )
  @steps = {}
  @routes_from_steps = {}
  @routes_to_steps = {}
  steps = procedure.steps
  steps.each do |step|
    from_route_array = []
    to_route_array = []
  	@routes.each do |route|
      from_route_array << route[1][:route].id if route[1][:route].from_step_id == step.id
  		to_route_array << route[1][:route].id if route[1][:route].to_step_id == step.id
  	end
    @routes_from_steps[step.id] = from_route_array
    @routes_to_steps[step.id] = to_route_array
    @steps[step.id] = step
  end
end

def is_route_untraversable?( route_id )
  untraversable = false
  untraversable = true if @routes[route_id][:status] == 'UNTRAVERSABLE'
  untraversable
end

def step_has_been_actualised_has_happened?( step_id )
  actualised_has_happened = false
  actualised_has_happened = true if @steps[step_id].actualisation_has_happened_count > 0
  actualised_has_happened
end

def target_step_of_route_with_id( route_id )
  @steps[@routes[route_id][:route].to_step_id]
  #Step.all.select( 's.*').joins( 'as s, routes as r' ).where( 's.id = r.to_step_id' ).where( "r.id = ?", route_id ).order( 's.id').first
end

def house_label_for_step_id( step_id )
  step = Step.find( step_id )
  step.house_label
end

### ==========
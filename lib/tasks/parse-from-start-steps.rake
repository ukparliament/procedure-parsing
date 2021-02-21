# The main parsing code and the individual parsing rules for source steps types are packaged into separate files.
# We require the main parsing code and the step type specific parsing code to be loaded.
require 'parsing/from-start-steps/parse'
require 'parsing/from-start-steps/and_step'
require 'parsing/from-start-steps/business_step'
require 'parsing/from-start-steps/decision_step'
require 'parsing/from-start-steps/not_step'
require 'parsing/from-start-steps/or_step'

# # Rake task to begin parsing.
task :parse_from_start_steps => :environment do
  
  # We set up an array to log the parsing.
  # Create as an instance variable because we want to write to and from it later.
  @parse_log = []
  
  # We create a set of arrays to store the target business steps of the routes we parse according to the value of the inbound route once parsed.
  # Created as instance variables because we want to write to and from them later.
  @caused_steps = []
  @allowed_steps = []
  @disallowed_yet_steps = []
  @disallowed_now_steps = []
  
  # We include the main parsing code.
  include PARSE
  
  # We include code for the different styles of parsing according to the source step type.
  include PARSE_AND_STEP
  include PARSE_BUSINESS_STEP
  include PARSE_DECISION_STEP
  include PARSE_NOT_STEP
  include PARSE_OR_STEP
  
  # We get the work package we're trying to parse.
  work_package = WorkPackage.find( ENV['wp'] )
  
  # We get the procedure the work package is subject to.
  procedure = work_package.parliamentary_procedure
  
  # We tell the user what we're attempting to do.
  puts "Attempting to parse work package #{ENV['wp']}, subject to the #{procedure.name.downcase} procedure."
  
  # We initialise a hash of additional route attributes keyed off the route.
  initialise_route_hash( work_package )
  
  # We set the parse count to zero.
  # This will be incremented every time we parse a route and used for reporting.
  # Created as an instance variable because we want to increment on each parse and report on it later.
  @parse_count = 0
  
  # We get the all the business  steps of the procedure the work package is subject to.
  # Created as an instance variable because we want to check it when parsing business steps.
  @start_steps = procedure.start_steps
  
  # HACK
  #@start_steps = procedure.business_steps
  # /HACK
  
  # We loop through the start steps ...
  @start_steps.each do |step|
    
    # ... and loop through the outbound routes of the start steps ...
    step.outbound_routes_in_procedure( procedure ).each do |route|
      
      # ... and parse each route.
      parse_route( route, step, procedure )
    end
  end
  
  
  # HACK
  puts "# Steps that will happen"
  @caused_steps.each do |caused_step|
    puts "#{caused_step.name} + (#{caused_step.house_label})"
  end 
  puts "# Steps that might happen"
  @allowed_steps.each do |allowed_step|
    puts "#{allowed_step.name} + (#{allowed_step.house_label})"
  end 
end


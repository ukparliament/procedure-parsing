# The main parsing code is packaged into a separate file.
# We require the main parsing code to be loaded.
require 'tasks/parsing/parse'

# Individual parsing rules for source steps types are packaged into separate files.
# We require the step type specific parsing code to be loaded.
#require 'tasks/parsing/and_step'
require 'tasks/parsing/business_step'
#require 'tasks/parsing/decision_step'
#require 'tasks/parsing/not_step'
require 'tasks/parsing/or_step'


# # Rake task to begin parsing.
task :parse => :environment do
  
  # We include the main parsing code.
  include PARSE
  
  # We include code for the different styles of parsing according to the source step type.
  #include PARSE_AND_STEP
  include PARSE_BUSINESS_STEP
  #include PARSE_DECISION_STEP
  #include PARSE_NOT_STEP
  include PARSE_OR_STEP
  
  # We set up an array to log the parsing.
  # Create as an instance variable because we want to write to and from it later.
  @parse_log = []
  
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
  
  # We get the start steps of the procedure the work package is subject to.
  # Created as an instance variable because we want to check it when parsing business steps.
  @start_steps = procedure.start_steps
  
  # We loop through the start steps ...
  @start_steps.each do |step|
    
    # ... and loop through the outbound routes of the start steps ...
    step.outbound_routes_in_procedure( procedure ).each do |route|
      
      # ... and parse each route.
      parse_route( route, step, procedure )
    end
  end
end


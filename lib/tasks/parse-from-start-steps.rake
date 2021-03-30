# The main parsing code and the individual parsing rules for source steps types are packaged into separate files.
# We require the main parsing code and the step type specific parsing code to be loaded.
require 'parsing/parse'
require 'parsing/and_step'
require 'parsing/business_step'
require 'parsing/decision_step'
require 'parsing/not_step'
require 'parsing/or_step'

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
  include PARSE_AND_STEP_FROM_START_STEPS
  include PARSE_BUSINESS_STEP_FROM_START_STEPS
  include PARSE_DECISION_STEP_FROM_START_STEPS
  include PARSE_NOT_STEP_FROM_START_STEPS
  include PARSE_OR_STEP_FROM_START_STEPS
  
  # We get the work package we're trying to parse.
  @work_package = WorkPackage.find( ENV['wp'] )
  
  # We get the procedure the work package is subject to.
  procedure = @work_package.parliamentary_procedure
  
  # We tell the user what we're attempting to do.
  puts "Attempting to parse work package #{ENV['wp']}, subject to the #{procedure.name.downcase} procedure."
  
  # We initialise a hash of additional route attributes keyed off the route.
  initialise_route_hash( @work_package )
  
  # We set the parse count to zero.
  # This will be incremented every time we parse a route and used for reporting.
  # Created as an instance variable because we want to increment on each parse and report on it later.
  @parse_count = 0
  
  # We get the all start steps of the procedure the work package is subject to.
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
  
  # ## We report the results.
  # Having parsed the tree ....
  # ... for each caused step ...
  puts "# Steps that should now happen"
  @caused_steps.each do |caused_step|
    
    # ... we report the step as caused to the user.
    puts "#{caused_step.name} + (#{caused_step.house_label})"
  end 
  
  # ... for each allowed step ...
  puts "# Steps that might now happen"
  @allowed_steps.each do |allowed_step|
    
    # ... we report the step as allowed to the user.
    puts "#{allowed_step.name} + (#{allowed_step.house_label})"
  end
  
  # ... for each disallowed yet step ...
  puts "# Steps that can't happen yet"
  @disallowed_yet_steps.each do |disallowed_yet_step|
    
    # ... we report the step as disallowed as yet to the user.
    puts "#{disallowed_yet_step.name} + (#{disallowed_yet_step.house_label})"
  end
  
  # ... for each disallowed now step ...
  puts "# Steps that can't happen now"
  @disallowed_now_steps.each do |disallowed_now_step|
    
    # ... we report the step as disallowed now to the user.
    puts "#{disallowed_now_step.name} + (#{disallowed_now_step.house_label})"
  end
end


The main parsing code and the individual parsing rules for source steps types are packaged into separate files.

We require the main parsing code to be loaded ...

require "#{Rails.root}/lib/parsing/parse"
... together with the code for parsing specific step types ...

require "#{Rails.root}/lib/parsing/and_step"
require "#{Rails.root}/lib/parsing/business_step"
require "#{Rails.root}/lib/parsing/decision_step"
require "#{Rails.root}/lib/parsing/not_step"
require "#{Rails.root}/lib/parsing/or_step"
... and the code for storing route attributes, determining route currency and assigning potential step states.

require "#{Rails.root}/lib/parsing/route_hash"
require "#{Rails.root}/lib/parsing/route_currency"
require "#{Rails.root}/lib/parsing/assign_potential_business_step_state"
# Work package controller

class WorkPackageController < ApplicationController
We include code for the main parsing rules ...

  include PARSE
... together with code for the different styles of parsing according to the type of the source step ...

  include PARSE_BUSINESS_STEP
  include PARSE_DECISION_STEP
  include PARSE_NOT_STEP
  include PARSE_AND_STEP
  include PARSE_OR_STEP
... and the code for storing route attributes, determining route currency and assigning potential step states.

  include PARSE_ROUTE_HASH
  include PARSE_ROUTE_CURRENCY
  include PARSE_ASSIGN_POTENTIAL_BUSINESS_STEP_STATE
  def show
    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
    parse
  end
## This method attempts to parse a work package subject to a procedure.

By taking actualised and non-actualised business steps and parsing the logical procedure map, we aim to determine business steps that may happen, should happen or should not happen in the future.

  def parse
We get the work package we're attempting to parse.

    work_package = params[:work_package]
    @work_package = WorkPackage.find( work_package )
We get the procedure the work package is subject to.

    procedure = @work_package.parliamentary_procedure
We set the parse pass count to zero.

The parse pass count will be incremented every time we attempt to parse a route.

The parse pass count is created as an instance variable because we want to increment on each parse and report from it later.

    @parse_pass_count = 0
We create an array to log the parsing.

The log is created as an instance variable because we want to write to it and report from it later.

    @parse_log = []
We write to the log, explaining what we're attempting to do.

    @parse_log << "Attempting to parse work package #{@work_package.id}, subject to the #{procedure.name.downcase} procedure."
Having successfully parsed a route to a business step, we can determine the potential state of that business step. The potential state of a business state may be caused to be actualised, allowed to be actualised, not yet actualisable or not now actualisable.

We create a set of arrays to store the target business steps of the routes we successfully parse - each array being named according to the potential state of the target step.

These are created as instance variables because we want to write to them and report from them later.

    @caused_steps = []
    @allowed_steps = []
    @disallowed_yet_steps = []
    @disallowed_now_steps = []
We initialise a hash of additional route attributes: these are attributes used only during the parsing process.

    initialise_route_hash( @work_package )
We get an array of the start steps in the procedure.

The array is created as an instance variable because we want to check it when parsing business steps.

    @start_steps = procedure.start_steps
We loop through the start steps in the procedure ...

    @start_steps.each do |step|
... then loop through the outbound routes of each start step ...

      step.outbound_routes_in_procedure( procedure ).each do |route|
... and parse each of those routes.

        parse_route( route, step, procedure )
      end
    end
  end
end
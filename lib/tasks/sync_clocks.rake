# We require open-uri to get the JSON from the egg timer.
require 'open-uri'

# # A rake task to reset end dates on business items necessitated by changes to sitting days.
# Many procedures have scrutiny periods set out in legislation, referred to here as 'clocks'.
# Scrutiny periods are usually based on patterns of sitting days in one or both Houses.
# For example: [paragraph 1 Section 7 of the Statutory Instruments Act 1946](https://www.legislation.gov.uk/ukpga/Geo6/9-10/36/section/7#section-7-1) sets out a 40 day objection period for bicameral instruments subject to the draft negative statutory instrument procedure, counting 40 days from the date of laying, based on days on which **either** House must be sitting or on a short adjournment.
# Should sitting days change whilst an instrument is before Parliament, clock periods need to be recalculated and the date of any business item actualising a business step which acts as the end step for a clock needs to be updated.
# This script automates that process.
task :reset_clocks => :environment do
  
  # We tell the user what we're attempting to do.
  puts "Resetting clocks"
  
  # We find all business items with a date in the future, which actualise a business step which acts as the end step for a clock.
  @updateable_clocks = BusinessItem.find_by_sql(
    "
      /* We return ... */
      SELECT
      
        /* ... the business item actualising the business step which acts as the end step for a clock. */
        bi1.*,
        
        /* ... the work package database ID. */
        wp.id as work_package_database_id,
        
        /* ... the work package triple store ID. */
        wp.triple_store_id as work_package_triplestore_id,
        
        /* ... the day count set on the work package, if any. */
        wp.day_count AS work_package_day_count,
        
        /* ... the day count set on the clock, if any. */
        c.day_count AS clock_day_count,
        
        /* ... the date on the business item actualising the business step which acts as the start step for a clock. */
        bi2.date AS clock_start_date,
        
        /* ... the date on the business item actualising the business step which acts as the end step for a clock. */
        bi1.date AS clock_end_date,
        
        /* ... the calculation style assigned to the work package. */
        wp.calculation_style_id AS calculation_style
      
      /* We join ... */
      FROM
        
        /* ... the work package in order to get the calculation style assigned to the work package and any day count set on the work package. */
        work_packages wp,
        
        /* ... the clock. */
        clocks c,
        
        /* ... the business item actualising the business step which acts as the end step for a clock. */
        business_items bi1,
        actualisations a1,
        steps s1,
        
        /* ... the business item actualising the business step which acts as the start step for a clock. */
        business_items bi2,
        actualisations a2,
        steps s2
      
      /* We constrain the query to only return business items actualising the business step which acts as the end step for a clock where the date of the business item date is today or later. */
      WHERE bi1.date >= '#{1.year.ago}'  -- NOTE: set to one year ago for testing.
      
      /* We join the business item actualising the business step which acts as the end step for a clock to its work package. */
      AND bi1.work_package_id = wp.id
      
      /* We constrain the query to only return business items in work packages where the clock has not been frozen. */
      AND wp.is_clock_frozen is false
      
      /* We join the business item to its actualisation of the business step acting as the end step for a clock. */
      AND bi1.id = a1.business_item_id
      AND a1.step_id = s1.id
      AND s1.id = c.end_step_id
      
      /* We join the business item to its actualisation of the business step acting as the start step for the same clock. */
      AND a2.business_item_id = bi2.id
      AND s2.id = a2.step_id
      AND c.start_step_id = s2.id
      
      /* ... ensuring that the business item actualising the business step which acts as the start step for a clock is in the same work package as the business item actualising the business step which acts as the end step of that clock. */
      AND bi2.work_package_id = wp.id
      
      /* We constrain the query to only include clocks forming part of the procedure the work package is subject to. */
      AND c.parliamentary_procedure_id = wp.parliamentary_procedure_id
      ;
    "
  )
  
  # We tell the user the number of business items whose date may need updating.
  puts "#{@updateable_clocks.count} business items may need their dates updating."
  
  # We set a counter to report how many business items were updated.
  updated_count = 0
  
  # For each business items whose date may need updating ...
  @updateable_clocks.each do |updateable_clock|
    
    # ... we set the current_clock end date.
    current_clock_end_date = updateable_clock.clock_end_date
    
    # ... we set the current clock start date.
    clock_start_date = updateable_clock.clock_start_date
    
    # ... we set the calculation style to be used.
    calculation_style = updateable_clock.calculation_style
    
    # If the work package has a day count override ...
    if updateable_clock.work_package_day_count
      
      # ... we set work package day count as the day count.
      day_count = updateable_clock.work_package_day_count
      
    # Otherwise, if the work package does not have a day count override ...
    else
      
      # ... we set the clock end day count as the day count.
      day_count = updateable_clock.clock_day_count
    end
    
    # We construct the egg timer request URL.
    egg_timer_request_url = "https://api.parliament.uk/egg-timer/calculator/calculate.json?calculation-style=#{calculation_style}&start-date=#{clock_start_date}&day-count=#{day_count}"
    
    # We request the egg timer URL and parse the returned JSON.
    request = URI.open( egg_timer_request_url )
    json = JSON.load( request )
    
    # We get the clock end date from the egg timer JSON.
    egg_timer_clock_end_date = json['anticipated_scrutiny_end_date'].to_date
    
    # If the egg timer clock end date differs from the current clock end date ...
    if egg_timer_clock_end_date != current_clock_end_date
      
      # ... we tell the user we're updating the clock.
      puts "======="
      puts "Resetting clock end date from #{current_clock_end_date} to #{egg_timer_clock_end_date} for work package #{updateable_clock.work_package_triplestore_id} (#{updateable_clock.work_package_database_id})"
      puts "Based on an egg timer calculation counting #{day_count} days from #{updateable_clock.clock_start_date} according to calculation style #{updateable_clock.calculation_style}."
      puts "Clock day count: #{updateable_clock.clock_day_count}"
      puts "Work package day count: #{updateable_clock.work_package_day_count}"
      puts "======="
      
      # ... we increment the number of business items needing updating.
      updated_count += 1
      
      # ... we update the date on the clock end business item ...
      updateable_clock.date = egg_timer_clock_end_date
      
      # ... and save the clock end business item.
      updateable_clock.save
    end 
  end
  
  # We tell the user the number of business items updated.
  puts "#{updated_count} business items required their dates updating."
end
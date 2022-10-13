require 'open-uri'

task :reset_clocks => :environment do
  puts "resetting clocks"
  
  # Find all business items actualising a clock end in the future.
  @updateable_clock_ends = BusinessItem.find_by_sql(
    "
      SELECT
        bi1.*,
        wp.day_count AS work_package_day_count,
        c.day_count AS clock_day_count,
        bi2.date AS clock_start_date,
        bi1.date AS clock_end_date,
        wp.calculation_style_id AS calculation_style
        
      FROM
        business_items bi1,
        work_packages wp,
        actualisations a1,
        steps s1,
        clocks c,
        steps s2,
        actualisations a2,
        business_items bi2
      
      /* bi1 is a business item with actualisation a1 of step s1 where s1 is the end step of clock c */  
      WHERE bi1.date >= '#{1.year.ago}'  -- only get business items with a date of today or in the future
      AND bi1.work_package_id = wp.id
      AND wp.is_clock_frozen is false -- only get business items in work packages where the clock has not been frozen
      AND bi1.id = a1.business_item_id
      AND a1.step_id = s1.id
      AND s1.id = c.end_step_id
      
      /* bi2 is a business item with actualisation a2 of step s2 where s2 is the start step of clock c */ 
      AND c.parliamentary_procedure_id = wp.parliamentary_procedure_id
      AND c.start_step_id = s2.id
      AND s2.id = a2.step_id
      AND a2.business_item_id = bi2.id
      AND bi2.work_package_id = wp.id
      ;
    "
  )
  @updateable_clock_ends.each do |clock_end_business_item|
    puts "======="
    puts "Clock start date: #{clock_end_business_item.clock_start_date}"
    puts "Work package day count: #{clock_end_business_item.work_package_day_count}"
    puts "Clock day count: #{clock_end_business_item.clock_day_count}"
    puts "Calculation style: #{clock_end_business_item.calculation_style}"
    puts "Current clock end date: #{clock_end_business_item.clock_end_date}"
    
    # We set the current_clock end date.
    current_clock_end_date = clock_end_business_item.clock_end_date
    
    # We set the variables used in egg timer request.
    clock_start_date = clock_end_business_item.clock_start_date
    calculation_style = clock_end_business_item.calculation_style
    
    
    # If the work package has a day count override ...
    if clock_end_business_item.work_package_day_count
      
      # ... we use the override as the day count.
      day_count = clock_end_business_item.work_package_day_count
      
    # Otherwise, if the work package does not have a day count override ...
    else
      
      # ... we use the day count as set on the clock.
      day_count = clock_end_business_item.clock_day_count
    end
    
    # We construct the egg timer request URL.
    egg_timer_request_url = "https://api.parliament.uk/egg-timer/calculator/calculate.json?calculation-style=#{calculation_style}&start-date=#{clock_start_date}&day-count=#{day_count}"
    
    # We request the egg timer URL and parse the returned JSON.
    request = URI.open( egg_timer_request_url )
    json = JSON.load( request )
    
    # We set the reset clock end date as a date.
    reset_clock_end_date = json['anticipated_scrutiny_end_date'].to_date
    puts "Reset clock end date: #{reset_clock_end_date}"
    
    # If the reset clock end date differs from the current clock end date ...
    if reset_clock_end_date != current_clock_end_date
      puts "resetting clock"
      
      # ... we update the date on the clock end business item ...
      clock_end_business_item.date = reset_clock_end_date
      
      # ... and save the clock end business item.
      clock_end_business_item.save
    end 
  end
end